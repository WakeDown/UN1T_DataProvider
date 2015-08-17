CREATE VIEW dbo.report
AS
SELECT     TOP (100) PERCENT st.name AS [Статус согласования], dt.name AS [Тип документа], ct.name AS [Вид договора], dp.name AS Подразделение, c.name AS [Юр. лицо Юнит], 
                      ctr.o2s5xclsha0 AS [Внешняя организация], ctr.o2s5xclow3t AS [ИНН внешней организации], d.amount AS Сумма, uu.full_name AS Менеджер, u.full_name AS [Офис-менеджер], 
                      CONVERT(NVARCHAR, a.dattim1, 104) AS [Дата начала согласования (когда создано)], CASE WHEN EXISTS
                          (SELECT     1
                            FROM          dbo.agr_states stt
                            WHERE      stt.id_agr_state = a.id_agr_state AND LOWER(stt.sys_name) NOT IN (LOWER('NEW'), LOWER('PROCESS'))) THEN
                          (SELECT     CONVERT(NVARCHAR, MAX(date_change), 104) AS date_change
                            FROM          dbo.agr_processes AS p
                            WHERE      (a.id_agreement = id_agreement) AND (enabled = 1)) ELSE 'В процессе' END AS [Дата окончания согласования], CASE WHEN CONVERT(DATE, a.dattim1) = CONVERT(DATE, 
                      CASE WHEN EXISTS
                          (SELECT     1
                            FROM          dbo.agr_states
                            WHERE      st.id_agr_state = id_agr_state AND LOWER(sys_name) NOT IN ('new', 'process')) THEN
                          (SELECT     MAX(date_change) AS date_change
                            FROM          dbo.agr_processes AS p
                            WHERE      (a.id_agreement = id_agreement) AND (enabled = 1)) ELSE GETDATE() END) THEN DATEDIFF(HOUR, a.dattim1, (CASE WHEN EXISTS
                          (SELECT     1
                            FROM          dbo.agr_states
                            WHERE      st.id_agr_state = id_agr_state AND LOWER(sys_name) NOT IN ('new', 'process')) THEN
                          (SELECT     MAX(date_change)
                            FROM          dbo.agr_processes AS p
                            WHERE      (a.id_agreement = id_agreement) AND (enabled = 1)) ELSE GETDATE() END)) ELSE ISNULL(DATEDIFF(HOUR, CONVERT(TIME, a.dattim1),
                          (SELECT     time
                            FROM          work_hours wh
                            WHERE      LOWER(wh.sys_name) = LOWER('end'))), 0) + ISNULL(DATEDIFF(HOUR,
                          (SELECT     time
                            FROM          work_hours wh
                            WHERE      LOWER(wh.sys_name) = LOWER('begin')), CONVERT(TIME, CASE WHEN EXISTS
                          (SELECT     1
                            FROM          dbo.agr_states
                            WHERE      st.id_agr_state = id_agr_state AND LOWER(sys_name) NOT IN ('new', 'process')) THEN
                          (SELECT     MAX(date_change)
                            FROM          dbo.agr_processes AS p
                            WHERE      (a.id_agreement = id_agreement) AND (enabled = 1)) ELSE GETDATE() END)), 0) + (CASE WHEN DATEDIFF(DAY, a.dattim1, CASE WHEN EXISTS
                          (SELECT     1
                            FROM          dbo.agr_states
                            WHERE      st.id_agr_state = id_agr_state AND LOWER(sys_name) NOT IN ('new', 'process')) THEN
                          (SELECT     MAX(date_change)
                            FROM          dbo.agr_processes AS p
                            WHERE      (a.id_agreement = id_agreement) AND (enabled = 1)) ELSE GETDATE() END) > 1 THEN ISNULL
                          ((SELECT     SUM(work_hours)
                              FROM         work_days
                              WHERE     date BETWEEN CONVERT(DATE, a.dattim1) AND CONVERT(DATE, (CASE WHEN EXISTS
                                                        (SELECT     1
                                                          FROM          dbo.agr_states
                                                          WHERE      st.id_agr_state = id_agr_state AND LOWER(sys_name) NOT IN ('new', 'process')) THEN
                                                        (SELECT     MAX(date_change)
                                                          FROM          dbo.agr_processes AS p
                                                          WHERE      (a.id_agreement = id_agreement) AND (enabled = 1)) ELSE GETDATE() END)) AND date NOT IN (CONVERT(DATE, a.dattim1), CONVERT(DATE, (CASE WHEN EXISTS
                                                        (SELECT     1
                                                          FROM          dbo.agr_states
                                                          WHERE      st.id_agr_state = id_agr_state AND LOWER(sys_name) NOT IN ('new', 'process')) THEN
                                                        (SELECT     MAX(date_change)
                                                          FROM          dbo.agr_processes AS p
                                                          WHERE      (a.id_agreement = id_agreement) AND (enabled = 1)) ELSE GETDATE() END)))), 0) ELSE 0 END) 
                      END AS [Продолжительность согласования в рабочих часах (с момента создания)]
FROM         dbo.agr_agreements AS a INNER JOIN
                      dbo.agr_documents AS d ON a.id_document = d.id_document INNER JOIN
                      dbo.agr_states AS st ON a.id_agr_state = st.id_agr_state INNER JOIN
                      dbo.agr_doc_types AS dt ON d.id_doc_type = dt.id_doc_type INNER JOIN
                      dbo.departments AS dp ON d.id_department = dp.id_department INNER JOIN
                      dbo.agr_contract_types AS ct ON d.id_contract_type = ct.id_contract_type INNER JOIN
                      dbo.companies AS c ON d.id_company = c.id_company INNER JOIN
                      dbo.users AS u ON a.id_agr_manager = u.id_user INNER JOIN
                      dbo.users AS uu ON d.id_doc_manager = uu.id_user INNER JOIN
                      [UFS-DB2].UNIT_WORK.UNIT_WORK.et6_o2s5xclp1y3 AS ctr ON d.id_contractor = ctr.recordid
WHERE     (a.enabled = 1) AND (a.old_id_agreement IS NULL)
ORDER BY a.id_agreement DESC

GO
GRANT SELECT
    ON OBJECT::[dbo].[report] TO [UN1T\sqlUnit_prog]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[report] TO [UN1T\Alexandr.Medvedevski]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[report] TO [UN1T\vera.spirina]
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
         Begin Table = "a"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 126
               Right = 213
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 6
               Left = 251
               Bottom = 126
               Right = 422
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "st"
            Begin Extent = 
               Top = 6
               Left = 460
               Bottom = 126
               Right = 629
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "dt"
            Begin Extent = 
               Top = 6
               Left = 667
               Bottom = 126
               Right = 836
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "dp"
            Begin Extent = 
               Top = 6
               Left = 874
               Bottom = 126
               Right = 1043
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ct"
            Begin Extent = 
               Top = 6
               Left = 1081
               Bottom = 126
               Right = 1252
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 246
               Right = 207
            End
            DisplayFlags = 280
            TopColumn = 0
         End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'report';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'         Begin Table = "u"
            Begin Extent = 
               Top = 126
               Left = 245
               Bottom = 246
               Right = 414
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "uu"
            Begin Extent = 
               Top = 126
               Left = 452
               Bottom = 246
               Right = 621
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ctr"
            Begin Extent = 
               Top = 126
               Left = 659
               Bottom = 246
               Right = 828
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'report';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'report';

