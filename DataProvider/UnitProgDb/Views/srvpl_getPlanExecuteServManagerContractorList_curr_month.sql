CREATE VIEW dbo.srvpl_getPlanExecuteServManagerContractorList_curr_month
AS
SELECT     TOP (100) PERCENT NAME AS contractor, id_contractor, id_manager, plan_cnt, done_cnt, plan_cnt - done_cnt AS residue, CONVERT(DECIMAL(10, 0), CONVERT(DECIMAL(10, 2), done_cnt) 
                      / CONVERT(DECIMAL(10, 2), plan_cnt) * 100) AS done_percent
FROM         (SELECT     NAME, id_contractor, id_manager, SUM([plan]) AS plan_cnt, SUM(done) AS done_cnt
                       FROM          (SELECT     ctr.NAME, ctr.id AS id_contractor, c.id_manager, 1 AS [plan], CASE WHEN EXISTS
                                                                          (SELECT     1
                                                                            FROM          dbo.srvpl_service_cames scm
                                                                            WHERE      scm.id_service_claim = sc.id_service_claim AND scm.enabled = 1) THEN 1 ELSE 0 END AS done
                                               FROM          dbo.srvpl_service_claims AS sc INNER JOIN
                                                                      dbo.srvpl_contract2devices AS c2d ON sc.id_contract2devices = c2d.id_contract2devices INNER JOIN
                                                                      dbo.srvpl_devices AS d ON sc.id_device = d.id_device INNER JOIN
                                                                      dbo.srvpl_contracts AS c ON sc.id_contract = c.id_contract INNER JOIN
                                                                      dbo.get_contractor(NULL) AS ctr ON c.id_contractor = ctr.id
                                               WHERE      (sc.enabled = 1) AND (d.enabled = 1) AND (c.enabled = 1) AND (c2d.enabled = 1) AND (MONTH(sc.planing_date) = MONTH(GETDATE())) AND (YEAR(sc.planing_date) 
                                                                      = YEAR(GETDATE())) AND (sc.id_service_engeneer IS NOT NULL)) AS t
                       GROUP BY NAME, id_contractor, id_manager) AS tt
ORDER BY contractor

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
      Begin ColumnWidths = 9
         Width = 284
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'srvpl_getPlanExecuteServManagerContractorList_curr_month';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'srvpl_getPlanExecuteServManagerContractorList_curr_month';

