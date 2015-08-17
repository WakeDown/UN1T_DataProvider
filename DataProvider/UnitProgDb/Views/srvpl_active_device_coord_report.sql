CREATE VIEW dbo.srvpl_active_device_coord_report
AS
SELECT     TOP (100) PERCENT c.number AS [Номер договора],
                          (SELECT     name_inn
                            FROM          dbo.get_contractor(c.id_contractor) AS get_contractor_1) AS Контрагент, dbo.srvpl_fnc(N'getDeviceShortCollectedNameNoBr', NULL, c2d.id_device, NULL, NULL) AS Аппарат,
                          (SELECT     display_name
                            FROM          dbo.users AS u
                            WHERE      (id_user = c2d.id_service_admin)) AS [Сервисный администратор], dbo.get_city_full_name(c2d.id_city) AS Город, c2d.object_name AS [Имя объекта], cit.coord AS Координаты
FROM         dbo.srvpl_contract2devices AS c2d INNER JOIN
                      dbo.srvpl_contracts AS c ON c2d.id_contract = c.id_contract INNER JOIN
                      dbo.srvpl_devices AS d ON c2d.id_device = d.id_device INNER JOIN
                      dbo.cities AS cit ON c2d.id_city = cit.id_city
WHERE     (c.enabled = 1) AND (d.enabled = 1) AND (c2d.enabled = 1) AND (dbo.srvpl_fnc(N'checkContractIsActiveNow', NULL, c.id_contract, NULL, NULL) = '1')
ORDER BY [Номер договора], Город

GO
GRANT SELECT
    ON OBJECT::[dbo].[srvpl_active_device_coord_report] TO [UN1T\Alexandr.Medvedevski]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[34] 4[14] 2[19] 3) )"
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
         Begin Table = "c2d"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 126
               Right = 243
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 281
               Bottom = 126
               Right = 466
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 6
               Left = 504
               Bottom = 126
               Right = 673
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cit"
            Begin Extent = 
               Top = 6
               Left = 711
               Bottom = 126
               Right = 880
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
         Width = 1500
         Width = 1500
         Width = 3480
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'srvpl_active_device_coord_report';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'srvpl_active_device_coord_report';

