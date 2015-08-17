CREATE VIEW dbo.zipcl_claims_report
AS
SELECT     TOP (100) PERCENT id_claim AS [ID Заявки], CONVERT(NVARCHAR, dattim1, 104) AS [Дата Заявки], ISNULL(dbo.srvpl_fnc(N'getDeviceShortCollectedName', NULL, id_device, NULL, NULL), 
                      ISNULL(device_model, '') + ' №' + serial_num) AS Модель, serial_num AS [Серийный номер],
                          (SELECT     TOP (1) name_inn
                            FROM          dbo.get_contractor(c.id_contractor) AS get_contractor_1) AS Контрагент, city AS Город,
                          (SELECT     name
                            FROM          dbo.zipcl_engeneer_conclusions AS ec
                            WHERE      (id_engeneer_conclusion = c.id_engeneer_conclusion)) AS [Состояние оборудования],
                          (SELECT     display_name
                            FROM          dbo.users AS u
                            WHERE      (id_user = c.id_engeneer)) AS Инженер,
                          (SELECT     display_name
                            FROM          dbo.users AS u
                            WHERE      (id_user = c.id_service_admin)) AS [Сервисный администратор],
                          (SELECT     display_name
                            FROM          dbo.users AS u
                            WHERE      (id_user = c.id_operator)) AS Оператор,
                          (SELECT     display_name
                            FROM          dbo.users AS u
                            WHERE      (id_user = c.id_manager)) AS Менеджер,
                          (SELECT     name
                            FROM          dbo.zipcl_claim_states AS st
                            WHERE      (id_claim_state = c.id_claim_state)) AS [Текущий статус заявки],
                          (SELECT     COUNT(1) AS Expr1
                            FROM          dbo.zipcl_claim_units AS clu
                            WHERE      (enabled = 1) AND (c.id_claim = id_claim)) AS [Количество ЗИП в данной заявке], cancel_comment AS [Причина отклонения],
                          (SELECT     (CASE WHEN cc.old_id_claim IS NULL THEN ISNULL
                                                       ((SELECT     TOP 1 ccc.dattim1
                                                           FROM         dbo.zipcl_zip_claims ccc
                                                           WHERE     ccc.old_id_claim = cc.id_claim AND ccc.id_claim_state = c3.id_claim_state
                                                           ORDER BY ccc.id_claim), ISNULL
                                                       ((SELECT     TOP 1 cc.dattim2
                                                           FROM         dbo.zipcl_zip_claims cc
                                                           WHERE     cc.old_id_claim = c3.id_claim
                                                           ORDER BY cc.id_claim DESC), cc.dattim1)) ELSE cc.dattim1 END) AS change_date
                            FROM          (SELECT     MIN(id_claim) AS id_claim, id_claim_state
                                                    FROM          dbo.zipcl_zip_claims AS c1
                                                    WHERE      (id_claim = c.id_claim) OR
                                                                           (old_id_claim = c.id_claim)
                                                    GROUP BY id_claim_state) AS c3 INNER JOIN
                                                   dbo.zipcl_zip_claims AS cc ON c3.id_claim = cc.id_claim INNER JOIN
                                                   dbo.zipcl_claim_states AS cs ON cc.id_claim_state = cs.id_claim_state
                            WHERE      (cc.id_claim_state =
                                                       (SELECT     id_claim_state
                                                         FROM          dbo.zipcl_claim_states
                                                         WHERE      (enabled = 1) AND (sys_name = 'SEND')))) AS Передано,
                          (SELECT     (CASE WHEN cc.old_id_claim IS NULL THEN ISNULL
                                                       ((SELECT     TOP 1 ccc.dattim1
                                                           FROM         dbo.zipcl_zip_claims ccc
                                                           WHERE     ccc.old_id_claim = cc.id_claim AND ccc.id_claim_state = c4.id_claim_state
                                                           ORDER BY ccc.id_claim), ISNULL
                                                       ((SELECT     TOP 1 cc.dattim2
                                                           FROM         dbo.zipcl_zip_claims cc
                                                           WHERE     cc.old_id_claim = c4.id_claim
                                                           ORDER BY cc.id_claim DESC), cc.dattim1)) ELSE cc.dattim1 END) AS change_date
                            FROM          (SELECT     MIN(id_claim) AS id_claim, id_claim_state
                                                    FROM          dbo.zipcl_zip_claims AS c1
                                                    WHERE      (id_claim = c.id_claim) OR
                                                                           (old_id_claim = c.id_claim)
                                                    GROUP BY id_claim_state) AS c4 INNER JOIN
                                                   dbo.zipcl_zip_claims AS cc ON c4.id_claim = cc.id_claim INNER JOIN
                                                   dbo.zipcl_claim_states AS cs ON cc.id_claim_state = cs.id_claim_state
                            WHERE      (cc.id_claim_state =
                                                       (SELECT     id_claim_state
                                                         FROM          dbo.zipcl_claim_states AS zipcl_claim_states_1
                                                         WHERE      (enabled = 1) AND (sys_name = 'MANSEL')))) AS Назначено,
                          (SELECT     (CASE WHEN cc.old_id_claim IS NULL THEN ISNULL
                                                       ((SELECT     TOP 1 ccc.dattim1
                                                           FROM         dbo.zipcl_zip_claims ccc
                                                           WHERE     ccc.old_id_claim = cc.id_claim AND ccc.id_claim_state = c9.id_claim_state
                                                           ORDER BY ccc.id_claim), ISNULL
                                                       ((SELECT     TOP 1 cc.dattim2
                                                           FROM         dbo.zipcl_zip_claims cc
                                                           WHERE     cc.old_id_claim = c9.id_claim
                                                           ORDER BY cc.id_claim DESC), cc.dattim1)) ELSE cc.dattim1 END) AS change_date
                            FROM          (SELECT     MIN(id_claim) AS id_claim, id_claim_state
                                                    FROM          dbo.zipcl_zip_claims AS c1
                                                    WHERE      (id_claim = c.id_claim) OR
                                                                           (old_id_claim = c.id_claim)
                                                    GROUP BY id_claim_state) AS c9 INNER JOIN
                                                   dbo.zipcl_zip_claims AS cc ON c9.id_claim = cc.id_claim INNER JOIN
                                                   dbo.zipcl_claim_states AS cs ON cc.id_claim_state = cs.id_claim_state
                            WHERE      (cc.id_claim_state =
                                                       (SELECT     id_claim_state
                                                         FROM          dbo.zipcl_claim_states AS zipcl_claim_states_6
                                                         WHERE      (enabled = 1) AND (sys_name = 'SUPPLY')))) AS [Запрошены цены],
                          (SELECT     (CASE WHEN cc.old_id_claim IS NULL THEN ISNULL
                                                       ((SELECT     TOP 1 ccc.dattim1
                                                           FROM         dbo.zipcl_zip_claims ccc
                                                           WHERE     ccc.old_id_claim = cc.id_claim AND ccc.id_claim_state = c5.id_claim_state
                                                           ORDER BY ccc.id_claim), ISNULL
                                                       ((SELECT     TOP 1 cc.dattim2
                                                           FROM         dbo.zipcl_zip_claims cc
                                                           WHERE     cc.old_id_claim = c5.id_claim
                                                           ORDER BY cc.id_claim DESC), cc.dattim1)) ELSE cc.dattim1 END) AS change_date
                            FROM          (SELECT     MIN(id_claim) AS id_claim, id_claim_state
                                                    FROM          dbo.zipcl_zip_claims AS c1
                                                    WHERE      (id_claim = c.id_claim) OR
                                                                           (old_id_claim = c.id_claim)
                                                    GROUP BY id_claim_state) AS c5 INNER JOIN
                                                   dbo.zipcl_zip_claims AS cc ON c5.id_claim = cc.id_claim INNER JOIN
                                                   dbo.zipcl_claim_states AS cs ON cc.id_claim_state = cs.id_claim_state
                            WHERE      (cc.id_claim_state =
                                                       (SELECT     id_claim_state
                                                         FROM          dbo.zipcl_claim_states AS zipcl_claim_states_2
                                                         WHERE      (enabled = 1) AND (sys_name = 'PRICE')))) AS [Проставлены цены],
                          (SELECT     (CASE WHEN cc.old_id_claim IS NULL THEN ISNULL
                                                       ((SELECT     TOP 1 ccc.dattim1
                                                           FROM         dbo.zipcl_zip_claims ccc
                                                           WHERE     ccc.old_id_claim = cc.id_claim AND ccc.id_claim_state = c7.id_claim_state
                                                           ORDER BY ccc.id_claim), ISNULL
                                                       ((SELECT     TOP 1 cc.dattim2
                                                           FROM         dbo.zipcl_zip_claims cc
                                                           WHERE     cc.old_id_claim = c7.id_claim
                                                           ORDER BY cc.id_claim DESC), cc.dattim1)) ELSE cc.dattim1 END) AS change_date
                            FROM          (SELECT     MIN(id_claim) AS id_claim, id_claim_state
                                                    FROM          dbo.zipcl_zip_claims AS c1
                                                    WHERE      (id_claim = c.id_claim) OR
                                                                           (old_id_claim = c.id_claim)
                                                    GROUP BY id_claim_state) AS c7 INNER JOIN
                                                   dbo.zipcl_zip_claims AS cc ON c7.id_claim = cc.id_claim INNER JOIN
                                                   dbo.zipcl_claim_states AS cs ON cc.id_claim_state = cs.id_claim_state
                            WHERE      (cc.id_claim_state =
                                                       (SELECT     id_claim_state
                                                         FROM          dbo.zipcl_claim_states AS zipcl_claim_states_4
                                                         WHERE      (enabled = 1) AND (sys_name = 'PRICEFAIL')))) AS [Не согласованы цены],
                          (SELECT     (CASE WHEN cc.old_id_claim IS NULL THEN ISNULL
                                                       ((SELECT     TOP 1 ccc.dattim1
                                                           FROM         dbo.zipcl_zip_claims ccc
                                                           WHERE     ccc.old_id_claim = cc.id_claim AND ccc.id_claim_state = c6.id_claim_state
                                                           ORDER BY ccc.id_claim), ISNULL
                                                       ((SELECT     TOP 1 cc.dattim2
                                                           FROM         dbo.zipcl_zip_claims cc
                                                           WHERE     cc.old_id_claim = c6.id_claim
                                                           ORDER BY cc.id_claim DESC), cc.dattim1)) ELSE cc.dattim1 END) AS change_date
                            FROM          (SELECT     MIN(id_claim) AS id_claim, id_claim_state
                                                    FROM          dbo.zipcl_zip_claims AS c1
                                                    WHERE      (id_claim = c.id_claim) OR
                                                                           (old_id_claim = c.id_claim)
                                                    GROUP BY id_claim_state) AS c6 INNER JOIN
                                                   dbo.zipcl_zip_claims AS cc ON c6.id_claim = cc.id_claim INNER JOIN
                                                   dbo.zipcl_claim_states AS cs ON cc.id_claim_state = cs.id_claim_state
                            WHERE      (cc.id_claim_state =
                                                       (SELECT     id_claim_state
                                                         FROM          dbo.zipcl_claim_states AS zipcl_claim_states_3
                                                         WHERE      (enabled = 1) AND (sys_name = 'PRICEOK')))) AS [Согласованы цены],
                          (SELECT     (CASE WHEN cc.old_id_claim IS NULL THEN ISNULL
                                                       ((SELECT     TOP 1 ccc.dattim1
                                                           FROM         dbo.zipcl_zip_claims ccc
                                                           WHERE     ccc.old_id_claim = cc.id_claim AND ccc.id_claim_state = c10.id_claim_state
                                                           ORDER BY ccc.id_claim), ISNULL
                                                       ((SELECT     TOP 1 cc.dattim2
                                                           FROM         dbo.zipcl_zip_claims cc
                                                           WHERE     cc.old_id_claim = c10.id_claim
                                                           ORDER BY cc.id_claim DESC), cc.dattim1)) ELSE cc.dattim1 END) AS change_date
                            FROM          (SELECT     MIN(id_claim) AS id_claim, id_claim_state
                                                    FROM          dbo.zipcl_zip_claims AS c1
                                                    WHERE      (id_claim = c.id_claim) OR
                                                                           (old_id_claim = c.id_claim)
                                                    GROUP BY id_claim_state) AS c10 INNER JOIN
                                                   dbo.zipcl_zip_claims AS cc ON c10.id_claim = cc.id_claim INNER JOIN
                                                   dbo.zipcl_claim_states AS cs ON cc.id_claim_state = cs.id_claim_state
                            WHERE      (cc.id_claim_state =
                                                       (SELECT     id_claim_state
                                                         FROM          dbo.zipcl_claim_states AS zipcl_claim_states_6
                                                         WHERE      (enabled = 1) AND (sys_name = 'ETDOCS')))) AS Оформлено,
                          (SELECT     (CASE WHEN cc.old_id_claim IS NULL THEN ISNULL
                                                       ((SELECT     TOP 1 ccc.dattim1
                                                           FROM         dbo.zipcl_zip_claims ccc
                                                           WHERE     ccc.old_id_claim = cc.id_claim AND ccc.id_claim_state = c8.id_claim_state
                                                           ORDER BY ccc.id_claim), ISNULL
                                                       ((SELECT     TOP 1 cc.dattim2
                                                           FROM         dbo.zipcl_zip_claims cc
                                                           WHERE     cc.old_id_claim = c8.id_claim
                                                           ORDER BY cc.id_claim DESC), cc.dattim1)) ELSE cc.dattim1 END) AS change_date
                            FROM          (SELECT     MIN(id_claim) AS id_claim, id_claim_state
                                                    FROM          dbo.zipcl_zip_claims AS c1
                                                    WHERE      (id_claim = c.id_claim) OR
                                                                           (old_id_claim = c.id_claim)
                                                    GROUP BY id_claim_state) AS c8 INNER JOIN
                                                   dbo.zipcl_zip_claims AS cc ON c8.id_claim = cc.id_claim INNER JOIN
                                                   dbo.zipcl_claim_states AS cs ON cc.id_claim_state = cs.id_claim_state
                            WHERE      (cc.id_claim_state =
                                                       (SELECT     id_claim_state
                                                         FROM          dbo.zipcl_claim_states AS zipcl_claim_states_5
                                                         WHERE      (enabled = 1) AND (sys_name = 'REQUESTNUM')))) AS [Указан номер требования],
                          (SELECT     (CASE WHEN cc.old_id_claim IS NULL THEN ISNULL
                                                       ((SELECT     TOP 1 ccc.dattim1
                                                           FROM         dbo.zipcl_zip_claims ccc
                                                           WHERE     ccc.old_id_claim = cc.id_claim AND ccc.id_claim_state = c12.id_claim_state
                                                           ORDER BY ccc.id_claim), ISNULL
                                                       ((SELECT     TOP 1 cc.dattim2
                                                           FROM         dbo.zipcl_zip_claims cc
                                                           WHERE     cc.old_id_claim = c12.id_claim
                                                           ORDER BY cc.id_claim DESC), cc.dattim1)) ELSE cc.dattim1 END) AS change_date
                            FROM          (SELECT     MIN(id_claim) AS id_claim, id_claim_state
                                                    FROM          dbo.zipcl_zip_claims AS c1
                                                    WHERE      (id_claim = c.id_claim) OR
                                                                           (old_id_claim = c.id_claim)
                                                    GROUP BY id_claim_state) AS c12 INNER JOIN
                                                   dbo.zipcl_zip_claims AS cc ON c12.id_claim = cc.id_claim INNER JOIN
                                                   dbo.zipcl_claim_states AS cs ON cc.id_claim_state = cs.id_claim_state
                            WHERE      (cc.id_claim_state =
                                                       (SELECT     id_claim_state
                                                         FROM          dbo.zipcl_claim_states AS zipcl_claim_states_6
                                                         WHERE      (enabled = 1) AND (sys_name = 'ETORDER')))) AS Заказано,
                          (SELECT     (CASE WHEN cc.old_id_claim IS NULL THEN ISNULL
                                                       ((SELECT     TOP 1 ccc.dattim1
                                                           FROM         dbo.zipcl_zip_claims ccc
                                                           WHERE     ccc.old_id_claim = cc.id_claim AND ccc.id_claim_state = c11.id_claim_state
                                                           ORDER BY ccc.id_claim), ISNULL
                                                       ((SELECT     TOP 1 cc.dattim2
                                                           FROM         dbo.zipcl_zip_claims cc
                                                           WHERE     cc.old_id_claim = c11.id_claim
                                                           ORDER BY cc.id_claim DESC), cc.dattim1)) ELSE cc.dattim1 END) AS change_date
                            FROM          (SELECT     MIN(id_claim) AS id_claim, id_claim_state
                                                    FROM          dbo.zipcl_zip_claims AS c1
                                                    WHERE      (id_claim = c.id_claim) OR
                                                                           (old_id_claim = c.id_claim)
                                                    GROUP BY id_claim_state) AS c11 INNER JOIN
                                                   dbo.zipcl_zip_claims AS cc ON c11.id_claim = cc.id_claim INNER JOIN
                                                   dbo.zipcl_claim_states AS cs ON cc.id_claim_state = cs.id_claim_state
                            WHERE      (cc.id_claim_state =
                                                       (SELECT     id_claim_state
                                                         FROM          dbo.zipcl_claim_states AS zipcl_claim_states_6
                                                         WHERE      (enabled = 1) AND (sys_name = 'ETPREP')))) AS [Готово к отгрузке],
                          (SELECT     (CASE WHEN cc.old_id_claim IS NULL THEN ISNULL
                                                       ((SELECT     TOP 1 ccc.dattim1
                                                           FROM         dbo.zipcl_zip_claims ccc
                                                           WHERE     ccc.old_id_claim = cc.id_claim AND ccc.id_claim_state = c13.id_claim_state
                                                           ORDER BY ccc.id_claim), ISNULL
                                                       ((SELECT     TOP 1 cc.dattim2
                                                           FROM         dbo.zipcl_zip_claims cc
                                                           WHERE     cc.old_id_claim = c13.id_claim
                                                           ORDER BY cc.id_claim DESC), cc.dattim1)) ELSE cc.dattim1 END) AS change_date
                            FROM          (SELECT     MIN(id_claim) AS id_claim, id_claim_state
                                                    FROM          dbo.zipcl_zip_claims AS c1
                                                    WHERE      (id_claim = c.id_claim) OR
                                                                           (old_id_claim = c.id_claim)
                                                    GROUP BY id_claim_state) AS c13 INNER JOIN
                                                   dbo.zipcl_zip_claims AS cc ON c13.id_claim = cc.id_claim INNER JOIN
                                                   dbo.zipcl_claim_states AS cs ON cc.id_claim_state = cs.id_claim_state
                            WHERE      (cc.id_claim_state =
                                                       (SELECT     id_claim_state
                                                         FROM          dbo.zipcl_claim_states AS zipcl_claim_states_6
                                                         WHERE      (enabled = 1) AND (sys_name = 'ETSHIP')))) AS Отгружено,
                          (SELECT     (CASE WHEN cc.old_id_claim IS NULL THEN ISNULL
                                                       ((SELECT     TOP 1 ccc.dattim1
                                                           FROM         dbo.zipcl_zip_claims ccc
                                                           WHERE     ccc.old_id_claim = cc.id_claim AND ccc.id_claim_state = c14.id_claim_state
                                                           ORDER BY ccc.id_claim), ISNULL
                                                       ((SELECT     TOP 1 cc.dattim2
                                                           FROM         dbo.zipcl_zip_claims cc
                                                           WHERE     cc.old_id_claim = c14.id_claim
                                                           ORDER BY cc.id_claim DESC), cc.dattim1)) ELSE cc.dattim1 END) AS change_date
                            FROM          (SELECT     MIN(id_claim) AS id_claim, id_claim_state
                                                    FROM          dbo.zipcl_zip_claims AS c1
                                                    WHERE      (id_claim = c.id_claim) OR
                                                                           (old_id_claim = c.id_claim)
                                                    GROUP BY id_claim_state) AS c14 INNER JOIN
                                                   dbo.zipcl_zip_claims AS cc ON c14.id_claim = cc.id_claim INNER JOIN
                                                   dbo.zipcl_claim_states AS cs ON cc.id_claim_state = cs.id_claim_state
                            WHERE      (cc.id_claim_state =
                                                       (SELECT     id_claim_state
                                                         FROM          dbo.zipcl_claim_states AS zipcl_claim_states_6
                                                         WHERE      (enabled = 1) AND (sys_name = 'DONE')))) AS Завершена, request_num AS [Номер требования]
FROM         dbo.zipcl_zip_claims AS c
WHERE     (enabled = 1)
ORDER BY [Дата Заявки]

GO
GRANT SELECT
    ON OBJECT::[dbo].[zipcl_claims_report] TO [UN1T\Alexandr.Medvedevski]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[zipcl_claims_report] TO [UN1T\sergey.kokoulin]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[zipcl_claims_report] TO [UN1T\Alexey.Kobzarev]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[15] 4[37] 2[44] 3) )"
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
               Left = 38
               Bottom = 126
               Right = 242
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
      Begin ColumnWidths = 21
         Width = 284
         Width = 1500
         Width = 2520
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 3630
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
         Column = 9810
         Alias = 2670
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'zipcl_claims_report';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'zipcl_claims_report';

