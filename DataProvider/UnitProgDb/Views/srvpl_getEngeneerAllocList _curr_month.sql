CREATE VIEW dbo.[srvpl_getEngeneerAllocList _curr_month]
AS
SELECT     TOP (100) PERCENT id_service_engeneer, engeneer_city, engeneer_org, engeneer_pos, service_engeneer, cnt, exec_claims, days_in_month, last_claim_day, last_exec_day, residue, norm, 
                      order_num, exec_days, cur_norm_exec, cur_norm, residue_days, exec_claims - cur_norm_exec AS exec_diff, CASE WHEN exec_claims IS NOT NULL AND 
                      exec_claims > 0 THEN (CONVERT(DECIMAL(10, 2), exec_claims) / CONVERT(DECIMAL(10, 2), cur_norm_exec)) * 100 ELSE 0 END AS norm_exec_percent
FROM         (SELECT     id_service_engeneer, engeneer_city, engeneer_org, engeneer_pos, service_engeneer, cnt, exec_claims, days_in_month, last_claim_day, last_exec_day, residue, norm, order_num, 
                                              exec_days, norm * exec_days AS cur_norm_exec, CONVERT(DECIMAL(10, 2), exec_claims) / CONVERT(DECIMAL(10, 2), exec_days) AS cur_norm, DATEDIFF(day, DATEADD(day, 
                                              1 - DAY(GETDATE()), GETDATE()), DATEADD(month, 1, DATEADD(day, 1 - DAY(GETDATE()), GETDATE()))) - exec_days AS residue_days
                       FROM          (SELECT     id_service_engeneer, engeneer_city, engeneer_org, engeneer_pos, service_engeneer, cnt, exec_claims, days_in_month, last_claim_day, last_exec_day, residue, norm, 
                                                                      order_num, DATEDIFF(day, DATEADD(day, 1 - DAY(GETDATE()), GETDATE()), last_exec_day) AS exec_days
                                               FROM          (SELECT     id_service_engeneer, engeneer_city, engeneer_org, engeneer_pos, service_engeneer, cnt, exec_claims, days_in_month, last_claim_day, 
                                                                                              CASE WHEN tt.last_claim_day < GETDATE() THEN GETDATE() ELSE tt.last_claim_day END AS last_exec_day, cnt - exec_claims AS residue, CONVERT(DECIMAL(10, 
                                                                                              2), cnt) / CONVERT(DECIMAL(10, 2), days_in_month) AS norm, CASE WHEN service_engeneer = 'не назначено' THEN 1 ELSE 0 END AS order_num
                                                                       FROM          (SELECT     id_service_engeneer,
                                                                                                                          (SELECT     city
                                                                                                                            FROM          dbo.users AS eng_u
                                                                                                                            WHERE      (id_user = t.id_service_engeneer)) AS engeneer_city,
                                                                                                                          (SELECT     company
                                                                                                                            FROM          dbo.users AS eng_u
                                                                                                                            WHERE      (id_user = t.id_service_engeneer)) AS engeneer_org,
                                                                                                                          (SELECT     position
                                                                                                                            FROM          dbo.users AS eng_u
                                                                                                                            WHERE      (id_user = t.id_service_engeneer)) AS engeneer_pos, ISNULL
                                                                                                                          ((SELECT     display_name
                                                                                                                              FROM         dbo.users AS u
                                                                                                                              WHERE     (id_user = t.id_service_engeneer)), 'не назначено') AS service_engeneer, COUNT(1) AS cnt, SUM(exec_claim) AS exec_claims, 
                                                                                                                      DATEDIFF(day, DATEADD(day, 1 - DAY(GETDATE()), GETDATE()), DATEADD(month, 1, DATEADD(day, 1 - DAY(GETDATE()), GETDATE()))) AS days_in_month, 
                                                                                                                      ISNULL
                                                                                                                          ((SELECT     MAX(scam.date_came) AS Expr1
                                                                                                                              FROM         dbo.srvpl_service_cames AS scam INNER JOIN
                                                                                                                                                    dbo.srvpl_service_claims AS sc2 ON scam.id_service_claim = sc2.id_service_claim INNER JOIN
                                                                                                                                                    dbo.srvpl_contract2devices AS c2d2 ON sc2.id_contract2devices = c2d2.id_contract2devices INNER JOIN
                                                                                                                                                    dbo.srvpl_contracts AS c2 ON c2d2.id_contract = c2.id_contract INNER JOIN
                                                                                                                                                    dbo.srvpl_devices AS d2 ON c2d2.id_device = d2.id_device
                                                                                                                              WHERE     (scam.enabled = 1) AND (sc2.enabled = 1) AND (c2d2.enabled = 1) AND (c2.enabled = 1) AND (d2.enabled = 1) AND 
                                                                                                                                                    (sc2.id_service_engeneer IS NOT NULL) AND (sc2.id_service_engeneer > 0) AND (GETDATE() IS NULL) OR
                                                                                                                                                    (scam.enabled = 1) AND (sc2.enabled = 1) AND (c2d2.enabled = 1) AND (c2.enabled = 1) AND (d2.enabled = 1) AND 
                                                                                                                                                    (sc2.id_service_engeneer IS NOT NULL) AND (sc2.id_service_engeneer > 0) AND (GETDATE() IS NOT NULL) AND 
                                                                                                                                                    (MONTH(sc2.planing_date) = MONTH(GETDATE())) AND (YEAR(sc2.planing_date) = YEAR(GETDATE()))), CONVERT(DATETIME, 
                                                                                                                      CONVERT(NVARCHAR, YEAR(GETDATE())) + '-' + CONVERT(NVARCHAR, MONTH(GETDATE())) + '-' + '01')) AS last_claim_day
                                                                                               FROM          (SELECT     sc.id_service_engeneer, CASE WHEN EXISTS
                                                                                                                                                  (SELECT     1
                                                                                                                                                    FROM          dbo.srvpl_service_cames scm
                                                                                                                                                    WHERE      scm.enabled = 1 AND sc.id_service_claim = scm.id_service_claim) THEN 1 ELSE 0 END AS exec_claim
                                                                                                                       FROM          dbo.srvpl_service_claims AS sc INNER JOIN
                                                                                                                                              dbo.srvpl_contract2devices AS c2d ON sc.id_contract2devices = c2d.id_contract2devices INNER JOIN
                                                                                                                                              dbo.srvpl_contracts AS c ON c2d.id_contract = c.id_contract INNER JOIN
                                                                                                                                              dbo.srvpl_devices AS d ON c2d.id_device = d.id_device
                                                                                                                       WHERE      (sc.enabled = 1) AND (c2d.enabled = 1) AND (c.enabled = 1) AND (d.enabled = 1) AND (GETDATE() IS NULL) OR
                                                                                                                                              (sc.enabled = 1) AND (c2d.enabled = 1) AND (c.enabled = 1) AND (d.enabled = 1) AND (GETDATE() IS NOT NULL) AND (MONTH(sc.planing_date) 
                                                                                                                                              = MONTH(GETDATE())) AND (YEAR(sc.planing_date) = YEAR(GETDATE()))) AS t
                                                                                               GROUP BY id_service_engeneer) AS tt) AS ttt) AS tttt) AS ttttt
ORDER BY order_num, service_engeneer

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
         Begin Table = "ttttt"
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
      Begin ColumnWidths = 20
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'srvpl_getEngeneerAllocList _curr_month';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'srvpl_getEngeneerAllocList _curr_month';

