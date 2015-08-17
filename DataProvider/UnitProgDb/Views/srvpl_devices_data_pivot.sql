CREATE VIEW dbo.srvpl_devices_data_pivot
AS
SELECT     TOP (100) PERCENT c.number, dbo.srvpl_get_device_name(t.id_device, NULL) AS device, ctr.name_inn AS contractor, t.id_contract, t.id_device, t.planing_date AS date, t.counter, 
                      t.counter_colour AS counter_color, t.place,
                          (SELECT     full_name
                            FROM          dbo.users AS u
                            WHERE      (enabled = 1) AND (id_user = t.id_creator)) AS creator, t.dattim1 AS date_create
FROM         (SELECT     c2d.id_contract, c2d.id_device, d.dattim1 AS planing_date, d.counter, d.counter_colour, 'srvpl_contract2devices' AS place, c2d.id_creator, c2d.dattim1
                       FROM          dbo.srvpl_contract2devices AS c2d INNER JOIN
                                              dbo.srvpl_devices AS d ON d.id_device = c2d.id_device INNER JOIN
                                              dbo.srvpl_contracts AS c ON c2d.id_contract = c.id_contract
                       WHERE      (d.enabled = 1) AND (c.enabled = 1) AND (c2d.enabled = 1) AND (d.counter IS NOT NULL) OR
                                              (d.enabled = 1) AND (c.enabled = 1) AND (c2d.enabled = 1) AND (d.counter_colour IS NOT NULL)
                       UNION ALL
                       SELECT     c2d.id_contract, c2d.id_device, cam.date_came AS planing_date, cam.counter, cam.counter_colour, 'srvpl_service_claims' AS place, cam.id_creator, cam.dattim1
                       FROM         dbo.srvpl_service_claims AS cl INNER JOIN
                                             dbo.srvpl_service_cames AS cam ON cl.id_service_claim = cam.id_service_claim INNER JOIN
                                             dbo.srvpl_contract2devices AS c2d ON c2d.id_contract2devices = cl.id_contract2devices INNER JOIN
                                             dbo.srvpl_devices AS d ON d.id_device = c2d.id_device INNER JOIN
                                             dbo.srvpl_contracts AS c ON c2d.id_contract = c.id_contract
                       WHERE     (d.enabled = 1) AND (c.enabled = 1) AND (c2d.enabled = 1) AND (cl.enabled = 1) AND (cam.enabled = 1)
                       UNION ALL
                       SELECT     (SELECT     TOP (1) id_contract
                                              FROM          dbo.srvpl_contracts
                                              WHERE      (enabled = 1) AND (id_contractor = r.id_contractor) AND (dbo.srvpl_fnc(N'checkContractIsActiveOnMonth', NULL, id_contract, r.date_request, NULL) = '1')) AS id_contract, 
                                             id_device, date_request AS planing_date, counter, counter_color, 'snmp_requests' AS place, NULL AS id_creator, dattim1
                       FROM         dbo.snmp_requests AS r) AS t INNER JOIN
                      dbo.srvpl_contracts AS c ON t.id_contract = c.id_contract INNER JOIN
                      dbo.srvpl_devices AS d ON t.id_device = d.id_device INNER JOIN
                      dbo.get_contractor(NULL) AS ctr ON c.id_contractor = ctr.id
WHERE     (t.id_contract IS NOT NULL) AND (t.id_device IS NOT NULL)
ORDER BY t.id_contract, t.id_device, date

GO
GRANT SELECT
    ON OBJECT::[dbo].[srvpl_devices_data_pivot] TO [UN1T\Alexandr.Medvedevski]
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
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 245
               Bottom = 126
               Right = 457
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 6
               Left = 495
               Bottom = 126
               Right = 664
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ctr"
            Begin Extent = 
               Top = 6
               Left = 702
               Bottom = 126
               Right = 871
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t"
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
      Begin ColumnWidths = 11
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
         Or', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'srvpl_devices_data_pivot';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N' = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'srvpl_devices_data_pivot';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'srvpl_devices_data_pivot';

