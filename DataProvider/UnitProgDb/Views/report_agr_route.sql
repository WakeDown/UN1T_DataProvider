CREATE VIEW dbo.report_agr_route
AS
SELECT     TOP (100) PERCENT d.name AS Подразделение, ct.name AS [Вид договора], CASE WHEN sh.amount1 = - 1 THEN 'без суммы' ELSE CONVERT(NVARCHAR, sh.amount1) END AS [Сумма от], 
                      (CASE WHEN sh.amount2 = 999999999999 THEN 'неограниченно' ELSE CONVERT(NVARCHAR, sh.amount2) END) AS [Сумма до], u.display_name AS [ФИО согл. лица], u.position AS Должность, 
                      m2s.order_num AS [Порядковый номер]
FROM         dbo.agr_matchers2schemes AS m2s INNER JOIN
                      dbo.agr_schemes AS sh ON m2s.id_agr_scheme = sh.id_agr_scheme INNER JOIN
                      dbo.departments AS d ON sh.id_department = d.id_department INNER JOIN
                      dbo.agr_contract_types AS ct ON sh.id_contract_type = ct.id_contract_type INNER JOIN
                      dbo.agr_matchers AS m ON m2s.id_agr_matcher = m.id_agr_matcher INNER JOIN
                      dbo.users AS u ON m.id_user = u.id_user
WHERE     (sh.enabled = 1) AND (m.enabled = 1) AND (m2s.enabled = 1)
ORDER BY Подразделение, [Вид договора], [Порядковый номер]

GO
GRANT SELECT
    ON OBJECT::[dbo].[report_agr_route] TO [sqlUnit_prog]
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
         Begin Table = "m2s"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 126
               Right = 232
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "sh"
            Begin Extent = 
               Top = 6
               Left = 270
               Bottom = 126
               Right = 459
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 6
               Left = 497
               Bottom = 126
               Right = 666
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ct"
            Begin Extent = 
               Top = 6
               Left = 704
               Bottom = 126
               Right = 875
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "m"
            Begin Extent = 
               Top = 6
               Left = 913
               Bottom = 126
               Right = 1083
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "u"
            Begin Extent = 
               Top = 6
               Left = 1121
               Bottom = 126
               Right = 1290
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
         Width = 2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'report_agr_route';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'550
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'report_agr_route';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'report_agr_route';

