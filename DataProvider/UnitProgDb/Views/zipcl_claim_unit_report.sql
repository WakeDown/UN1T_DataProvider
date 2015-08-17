/*ID заявки	№ ServiceDesk	Дата заявки	Каталожный номер	Номенклатурный номер	Наименование ЗИП	Модель КМТ	Серийный номер	Инженер	Сервисный администратор	Менеджер	Оператор	Контрагент*/
CREATE VIEW dbo.zipcl_claim_unit_report
AS
SELECT     TOP (100) PERCENT cu.id_claim AS [ID Заявки], c.service_desk_num AS [№ ServiceDesk], CONVERT(NVARCHAR, c.dattim1, 104) AS [Дата Заявки], cu.catalog_num AS [Каталожный номер], 
                      cu.nomenclature_num AS [Номенклатурный номер], cu.name AS [Наименование ЗИП], ISNULL(dbo.srvpl_fnc(N'getDeviceShortCollectedNameNoSerialNoBr', NULL, c.id_device, NULL, NULL), 
                      ISNULL(c.device_model, '')) AS [Модель КМТ], c.serial_num AS [Серийный номер],
                          (SELECT     display_name
                            FROM          dbo.users AS u
                            WHERE      (id_user = c.id_engeneer)) AS Инженер,
                          (SELECT     display_name
                            FROM          dbo.users AS u
                            WHERE      (id_user = c.id_service_admin)) AS [Сервисный администратор],
                          (SELECT     display_name
                            FROM          dbo.users AS u
                            WHERE      (id_user = c.id_manager)) AS Менеджер,
                          (SELECT     display_name
                            FROM          dbo.users AS u
                            WHERE      (id_user = c.id_operator)) AS Оператор,
                          (SELECT     TOP (1) name_inn
                            FROM          dbo.get_contractor(c.id_contractor) AS get_contractor_1) AS Контрагент
FROM         dbo.zipcl_claim_units AS cu INNER JOIN
                      dbo.zipcl_zip_claims AS c ON cu.id_claim = c.id_claim
WHERE     (c.enabled = 1) AND (cu.enabled = 1)
ORDER BY c.id_claim DESC

GO
GRANT SELECT
    ON OBJECT::[dbo].[zipcl_claim_unit_report] TO [UN1T\sergey.kokoulin]
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
         Begin Table = "cu"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 126
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 285
               Bottom = 126
               Right = 489
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
      Begin ColumnWidths = 14
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'zipcl_claim_unit_report';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'zipcl_claim_unit_report';

