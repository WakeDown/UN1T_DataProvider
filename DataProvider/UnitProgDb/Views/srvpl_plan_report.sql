CREATE VIEW dbo.srvpl_plan_report
AS
SELECT     dbo.srvpl_fnc(N'getDeviceModelShortCollectedName', NULL, d.id_device_model, NULL, NULL) AS Модель, d.serial_num AS [Серийный номер], c.number AS [№ договора], 
                      c.date_begin AS [Дата начала действия договора], c.date_end AS [Дата окончания действия договора],
                          (SELECT     name_inn
                            FROM          dbo.get_contractor(c.id_contractor) AS get_contractor_1) AS Контрагент, ISNULL(cit.region + CASE WHEN cit.locality IS NULL AND cit.name IS NULL AND cit.area IS NULL 
                      THEN '' ELSE ', ' END, '') + ISNULL(cit.area + CASE WHEN cit.locality IS NULL AND cit.name IS NULL THEN '' ELSE ', ' END, '') + ISNULL(cit.name + CASE WHEN cit.locality IS NULL 
                      THEN '' ELSE ', ' END, '') + ISNULL(cit.locality, '') + ' ' + c2d.address + ' ' + c2d.object_name AS [Адрес места расположения],
                          (SELECT     display_name
                            FROM          dbo.users AS u
                            WHERE      (c.id_manager = id_user)) AS Менеджер,
                          (SELECT     display_name
                            FROM          dbo.users AS u
                            WHERE      (c2d.id_service_admin = id_user)) AS [Сервисный администратор],
                          (SELECT     name
                            FROM          dbo.srvpl_service_intervals AS si
                            WHERE      (c2d.id_service_interval = id_service_interval)) AS [Интервал обслуживания], DATENAME(month, sc.planing_date) + ' ' + DATENAME(year, sc.planing_date) AS [Месяц обслуживания], 
                      scs.name AS Статус
FROM         dbo.srvpl_service_claims AS sc INNER JOIN
                      dbo.srvpl_contract2devices AS c2d ON sc.id_contract2devices = c2d.id_contract2devices INNER JOIN
                      dbo.srvpl_devices AS d ON c2d.id_device = d.id_device INNER JOIN
                      dbo.srvpl_contracts AS c ON c2d.id_contract = c.id_contract INNER JOIN
                      dbo.cities AS cit ON c2d.id_city = cit.id_city INNER JOIN
                      dbo.srvpl_service_claim_statuses AS scs ON scs.id_service_claim_status = sc.id_service_claim_status
WHERE     (sc.enabled = 1)

GO
GRANT SELECT
    ON OBJECT::[dbo].[srvpl_plan_report] TO [UN1T\Alexandr.Medvedevski]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[8] 2[44] 3) )"
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
         Begin Table = "sc"
            Begin Extent = 
               Top = 6
               Left = 892
               Bottom = 126
               Right = 1094
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c2d"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 126
               Right = 223
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 6
               Left = 261
               Bottom = 126
               Right = 430
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 468
               Bottom = 126
               Right = 647
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cit"
            Begin Extent = 
               Top = 6
               Left = 685
               Bottom = 126
               Right = 854
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "scs"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 246
               Right = 240
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
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'srvpl_plan_report';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'1500
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'srvpl_plan_report';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'srvpl_plan_report';

