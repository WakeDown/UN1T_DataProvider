CREATE VIEW dbo.srvpl_device_list
AS
SELECT     id_device, model, serial_num, speed, counter, age_count, instalation_date, linked_now, contract_num, id_contract, CASE WHEN age_count > 5 THEN 5 ELSE age_count END AS age
FROM         (SELECT     d.id_device, dbo.srvpl_fnc(N'getDeviceModelShortCollectedName', NULL, d.id_device_model, NULL, NULL) AS model, d.serial_num, dm.speed, d.counter, 
                                              CASE WHEN instalation_date IS NOT NULL THEN ABS(DATEDIFF(month, instalation_date, GETDATE())) / 12 ELSE age END AS age_count, d.instalation_date, 
                                              dbo.srvpl_fnc(N'checkDeviceIsLinkedNow', NULL, d.id_device, NULL, NULL) AS linked_now,
                                                  (SELECT     TOP (1) c.number
                                                    FROM          dbo.srvpl_contract2devices AS c2d INNER JOIN
                                                                           dbo.srvpl_contracts AS c ON c2d.id_contract = c.id_contract
                                                    WHERE      (c2d.enabled = 1) AND (c2d.id_device = d.id_device) AND (dbo.srvpl_fnc(N'checkContractIsActiveNow', NULL, c2d.id_contract, NULL, NULL) = '1')
                                                    ORDER BY c2d.id_contract2devices DESC) AS contract_num,
                                                  (SELECT     TOP (1) c2d.id_contract
                                                    FROM          dbo.srvpl_contract2devices AS c2d INNER JOIN
                                                                           dbo.srvpl_contracts AS c ON c2d.id_contract = c.id_contract
                                                    WHERE      (c2d.enabled = 1) AND (c2d.id_device = d.id_device) AND (dbo.srvpl_fnc(N'checkContractIsActiveNow', NULL, c2d.id_contract, NULL, NULL) = '1')
                                                    ORDER BY c2d.id_contract2devices DESC) AS id_contract
                       FROM          dbo.srvpl_devices AS d INNER JOIN
                                              dbo.srvpl_device_models AS dm ON d.id_device_model = dm.id_device_model
                       WHERE      (d.old_id_device IS NULL) AND (d.enabled = 1)) AS T

GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[17] 4[11] 2[39] 3) )"
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
         Begin Table = "T"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 126
               Right = 207
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'srvpl_device_list';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'srvpl_device_list';

