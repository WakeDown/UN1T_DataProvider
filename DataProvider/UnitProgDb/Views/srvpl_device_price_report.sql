CREATE VIEW dbo.srvpl_device_price_report
AS
SELECT     device, tariff_pre * (CASE WHEN speed_coefficient > 1 THEN speed_coefficient ELSE ctype_coefficient END) AS Итого, tariff_pre AS [Тариф предварительный], 
                      speed_coefficient AS [Коэффициент скорости], ctype_coefficient AS [Коэффициент способа печати], speed_price AS [Цена за скорость], pformat_price AS [Цена за формат], 
                      ptype_price AS [Цена за тип печати], age_price AS [Цена за возраст], adf_option_price AS [Цена за ADF], finisher_option_price AS [Цена за Finisher], tray_option_price AS [Цена за Tray]
FROM         (SELECT     device, ISNULL(speed_price, 0) AS speed_price, ISNULL(pformat_price, 0) AS pformat_price, ISNULL(ptype_price, 0) AS ptype_price, ISNULL(age_price, 0) AS age_price, 
                                              ISNULL(adf_option_price, 0) AS adf_option_price, ISNULL(finisher_option_price, 0) AS finisher_option_price, ISNULL(tray_option_price, 0) AS tray_option_price, ISNULL(speed_price, 0) 
                                              + ISNULL(pformat_price, 0) + ISNULL(ptype_price, 0) + ISNULL(age_price, 0) + ISNULL(adf_option_price, 0) + ISNULL(finisher_option_price, 0) + ISNULL(tray_option_price, 0) AS tariff_pre, 
                                              ISNULL(ctype_coefficient, 1) AS ctype_coefficient, ISNULL(speed_coefficient, 1) AS speed_coefficient
                       FROM          (SELECT     dbo.srvpl_fnc(N'getDeviceShortCollectedNameNoBr', NULL, d.id_device, NULL, NULL) AS device,
                                                                          (SELECT     TOP (1) price * m.speed AS Expr1
                                                                            FROM          dbo.srvpl_tariff_features
                                                                            WHERE      (enabled = 1) AND (UPPER(sys_name) = 'SPEED')) AS speed_price,
                                                                          (SELECT     TOP (1) tf.price
                                                                            FROM          dbo.srvpl_tariff_features AS tf INNER JOIN
                                                                                                   dbo.srvpl_device_imprints AS di ON m.id_device_imprint = di.id_device_imprint AND UPPER(tf.sys_name) = UPPER(di.sys_name)
                                                                            WHERE      (tf.enabled = 1)) AS pformat_price,
                                                                          (SELECT     TOP (1) tf.price
                                                                            FROM          dbo.srvpl_tariff_features AS tf INNER JOIN
                                                                                                   dbo.srvpl_print_types AS pt ON m.id_print_type = pt.id_print_type AND UPPER(tf.sys_name) = UPPER(pt.sys_name)
                                                                            WHERE      (tf.enabled = 1)) AS ptype_price,
                                                                          (SELECT     TOP (1) price
                                                                            FROM          dbo.srvpl_tariff_features AS tf
                                                                            WHERE      (enabled = 1) AND (UPPER(sys_name) = 'AGE' + CONVERT(NVARCHAR(10), CASE WHEN d .age > 5 THEN 5 ELSE CASE WHEN d .age IS NULL 
                                                                                                   THEN 3 ELSE d .age END END))) AS age_price,
                                                                          (SELECT     TOP (1) price
                                                                            FROM          dbo.srvpl_tariff_features AS tf
                                                                            WHERE      (enabled = 1) AND (UPPER(sys_name) =
                                                                                                       (SELECT     UPPER(do.sys_name) AS Expr1
                                                                                                         FROM          dbo.srvpl_device2options AS d2o INNER JOIN
                                                                                                                                dbo.srvpl_device_options AS do ON do.id_device_option = d2o.id_device_option
                                                                                                         WHERE      (d2o.enabled = 1) AND (d2o.id_device = d.id_device) AND (UPPER(do.sys_name) = 'OPTADF')))) AS adf_option_price,
                                                                          (SELECT     TOP (1) price
                                                                            FROM          dbo.srvpl_tariff_features AS tf
                                                                            WHERE      (enabled = 1) AND (UPPER(sys_name) =
                                                                                                       (SELECT     UPPER(do.sys_name) AS Expr1
                                                                                                         FROM          dbo.srvpl_device2options AS d2o INNER JOIN
                                                                                                                                dbo.srvpl_device_options AS do ON do.id_device_option = d2o.id_device_option
                                                                                                         WHERE      (d2o.enabled = 1) AND (d2o.id_device = d.id_device) AND (UPPER(do.sys_name) = 'OPTFIN')))) AS finisher_option_price,
                                                                          (SELECT     TOP (1) price
                                                                            FROM          dbo.srvpl_tariff_features AS tf
                                                                            WHERE      (enabled = 1) AND (UPPER(sys_name) =
                                                                                                       (SELECT     UPPER(do.sys_name) AS Expr1
                                                                                                         FROM          dbo.srvpl_device2options AS d2o INNER JOIN
                                                                                                                                dbo.srvpl_device_options AS do ON do.id_device_option = d2o.id_device_option
                                                                                                         WHERE      (d2o.enabled = 1) AND (d2o.id_device = d.id_device) AND (UPPER(do.sys_name) = 'OPTTRAY')))) AS tray_option_price,
                                                                          (SELECT     TOP (1) price
                                                                            FROM          dbo.srvpl_tariff_features AS tf
                                                                            WHERE      (enabled = 1) AND (UPPER(sys_name) =
                                                                                                       (SELECT     UPPER(sys_name) AS Expr1
                                                                                                         FROM          dbo.srvpl_cartridge_types AS ct
                                                                                                         WHERE      (id_cartridge_type = m.id_cartridge_type)))) AS ctype_coefficient,
                                                                          (SELECT     TOP (1) price
                                                                            FROM          dbo.srvpl_tariff_features AS tf
                                                                            WHERE      (enabled = 1) AND (UPPER(sys_name) = 'SPEEDUND89') AND (m.speed > 89)) AS speed_coefficient
                                               FROM          dbo.srvpl_devices AS d INNER JOIN
                                                                      dbo.srvpl_device_models AS m ON d.id_device_model = m.id_device_model
                                               WHERE      (d.enabled = 1)) AS t) AS tt

GO
GRANT SELECT
    ON OBJECT::[dbo].[srvpl_device_price_report] TO [UN1T\Alexandr.Medvedevski]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tt"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 126
               Right = 227
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 13
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'srvpl_device_price_report';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'srvpl_device_price_report';

