
-- =============================================
-- Author:		anton.rehov
-- Create date: 15.08.2013
-- Description:	Процедура уровня вставки обновления данных в БД
-- =============================================
CREATE PROCEDURE [dbo].[sk_agreements]
    @action NVARCHAR(50) = NULL ,
    @sp_test BIT = NULL --переменная для тестирования
    ,
    @id_user INT = NULL ,
    @number NVARCHAR(50) = NULL ,
    @reg_number NVARCHAR(15) = NULL ,
    @doc_date DATETIME = NULL ,
    @id_department INT = NULL ,
    @id_contract_type INT = NULL ,
    @id_company INT = NULL ,
    @id_contractor INT = NULL ,
    @amount MONEY = NULL ,
    @id_doc_manager INT = NULL ,
    @id_creator INT = NULL ,
    @id_agr_scheme INT = NULL ,
    @name NVARCHAR(MAX) = NULL ,
    @amount1 MONEY = NULL ,
    @amount2 MONEY = NULL ,
    @order_num INT = NULL ,
    @id_main_matcher INT = NULL ,
    @id_agr_matcher INT = NULL ,
    @id_agr_manager INT = NULL ,
    @id_agr_state INT = NULL ,
    @id_agreement INT = NULL ,
    @id_agr_result INT = NULL ,
    @comment NVARCHAR(MAX) = NULL ,
    @id_agr_process INT = NULL ,
    @id_doc_type INT = NULL ,
    @descr NVARCHAR(MAX) = NULL ,
    @agr_type NVARCHAR(MAX) = NULL ,
    @doc_type NVARCHAR(50) = NULL ,
    @available BIT = NULL ,
    @id_matchers2schemes INT = NULL ,
    @id_document INT = NULL ,
    @contract_num NVARCHAR(15) = NULL ,
    @contract_date DATETIME = NULL ,
    @add_docs NVARCHAR(MAX) = NULL ,
    @id_updater INT = NULL ,
    @text NVARCHAR(MAX) = NULL ,
    @file_path NVARCHAR(MAX) = NULL ,
    @id_doc_scan INT = NULL ,
    @display_name NVARCHAR(150) = NULL ,
    @id_doc_type_option INT = NULL ,
    @id_dt2dto INT = NULL ,
    @matchers_notice BIT = NULL ,
    @id_agr_scheme_type INT = NULL ,
    @id_parent INT = NULL ,
    @is_electron BIT = NULL
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @id_program INT ,
            @log_params NVARCHAR(MAX)

        SELECT TOP 1
                @id_program = id_program
        FROM    programs p
        WHERE   p.enabled = 1
                AND LOWER(p.sys_name) = LOWER('AGREEMENTS')

        SELECT  @log_params = CASE WHEN @action IS NULL THEN ''
                                   ELSE ' @action='
                                        + CONVERT(NVARCHAR, @action)
                              END + CASE WHEN @sp_test IS NULL THEN ''
                                         ELSE ' @sp_test='
                                              + CONVERT(NVARCHAR, @sp_test)
                                    END
                + CASE WHEN @id_agr_scheme_type IS NULL THEN ''
                       ELSE ' @id_agr_scheme_type='
                            + CONVERT(NVARCHAR, @id_agr_scheme_type)
                  END + CASE WHEN @id_dt2dto IS NULL THEN ''
                             ELSE ' @id_dt2dto='
                                  + CONVERT(NVARCHAR, @id_dt2dto)
                        END + CASE WHEN @id_doc_type_option IS NULL THEN ''
                                   ELSE ' @id_doc_type_option='
                                        + CONVERT(NVARCHAR, @id_doc_type_option)
                              END + CASE WHEN @display_name IS NULL THEN ''
                                         ELSE ' @display_name='
                                              + CONVERT(NVARCHAR, @display_name)
                                    END + CASE WHEN @file_path IS NULL THEN ''
                                               ELSE ' @file_path='
                                                    + CONVERT(NVARCHAR, @file_path)
                                          END
                + CASE WHEN @id_doc_scan IS NULL THEN ''
                       ELSE ' @id_doc_scan=' + CONVERT(NVARCHAR, @id_doc_scan)
                  END + CASE WHEN @text IS NULL THEN ''
                             ELSE ' @text=' + CONVERT(NVARCHAR, @text)
                        END + CASE WHEN @id_updater IS NULL THEN ''
                                   ELSE ' @id_updater='
                                        + CONVERT(NVARCHAR, @id_updater)
                              END + CASE WHEN @contract_date IS NULL THEN ''
                                         ELSE ' @contract_date='
                                              + CONVERT(NVARCHAR, @contract_date)
                                    END
                + CASE WHEN @contract_num IS NULL THEN ''
                       ELSE ' @contract_num='
                            + CONVERT(NVARCHAR, @contract_num)
                  END + CASE WHEN @number IS NULL THEN ''
                             ELSE ' @number=' + CONVERT(NVARCHAR, @number)
                        END + CASE WHEN @reg_number IS NULL THEN ''
                                   ELSE ' @reg_number='
                                        + CONVERT(NVARCHAR, @reg_number)
                              END + CASE WHEN @doc_date IS NULL THEN ''
                                         ELSE ' @doc_date='
                                              + CONVERT(NVARCHAR, @doc_date)
                                    END
                + CASE WHEN @id_department IS NULL THEN ''
                       ELSE ' @id_department='
                            + CONVERT(NVARCHAR, @id_department)
                  END + CASE WHEN @id_contract_type IS NULL THEN ''
                             ELSE ' @id_contract_type='
                                  + CONVERT(NVARCHAR, @id_contract_type)
                        END + CASE WHEN @id_company IS NULL THEN ''
                                   ELSE ' @id_company='
                                        + CONVERT(NVARCHAR, @id_company)
                              END + CASE WHEN @id_contractor IS NULL THEN ''
                                         ELSE ' @id_contractor='
                                              + CONVERT(NVARCHAR, @id_contractor)
                                    END + CASE WHEN @amount IS NULL THEN ''
                                               ELSE ' @amount='
                                                    + CONVERT(NVARCHAR, @amount)
                                          END
                + CASE WHEN @id_doc_manager IS NULL THEN ''
                       ELSE ' @id_doc_manager='
                            + CONVERT(NVARCHAR, @id_doc_manager)
                  END + CASE WHEN @id_creator IS NULL THEN ''
                             ELSE ' @id_creator='
                                  + CONVERT(NVARCHAR, @id_creator)
                        END + CASE WHEN @id_agr_scheme IS NULL THEN ''
                                   ELSE ' @id_agr_scheme='
                                        + CONVERT(NVARCHAR, @id_agr_scheme)
                              END + CASE WHEN @name IS NULL THEN ''
                                         ELSE ' @name='
                                              + CONVERT(NVARCHAR, @name)
                                    END + CASE WHEN @amount1 IS NULL THEN ''
                                               ELSE ' @amount1='
                                                    + CONVERT(NVARCHAR, @amount1)
                                          END
                + CASE WHEN @amount2 IS NULL THEN ''
                       ELSE ' @amount2=' + CONVERT(NVARCHAR, @amount2)
                  END + CASE WHEN @order_num IS NULL THEN ''
                             ELSE ' @order_num='
                                  + CONVERT(NVARCHAR, @order_num)
                        END + CASE WHEN @id_main_matcher IS NULL THEN ''
                                   ELSE ' @id_main_matcher='
                                        + CONVERT(NVARCHAR, @id_main_matcher)
                              END + CASE WHEN @id_agr_matcher IS NULL THEN ''
                                         ELSE ' @id_agr_matcher='
                                              + CONVERT(NVARCHAR, @id_agr_matcher)
                                    END
                + CASE WHEN @id_agr_manager IS NULL THEN ''
                       ELSE ' @id_agr_manager='
                            + CONVERT(NVARCHAR, @id_agr_manager)
                  END + CASE WHEN @id_agr_state IS NULL THEN ''
                             ELSE ' @id_agr_state='
                                  + CONVERT(NVARCHAR, @id_agr_state)
                        END + CASE WHEN @id_agreement IS NULL THEN ''
                                   ELSE ' @id_agreement='
                                        + CONVERT(NVARCHAR, @id_agreement)
                              END + CASE WHEN @id_agr_result IS NULL THEN ''
                                         ELSE ' @id_agr_result='
                                              + CONVERT(NVARCHAR, @id_agr_result)
                                    END + CASE WHEN @comment IS NULL THEN ''
                                               ELSE ' @comment='
                                                    + CONVERT(NVARCHAR, @comment)
                                          END
                + CASE WHEN @id_agr_process IS NULL THEN ''
                       ELSE ' @id_agr_process='
                            + CONVERT(NVARCHAR, @id_agr_process)
                  END + CASE WHEN @id_doc_type IS NULL THEN ''
                             ELSE ' @id_doc_type='
                                  + CONVERT(NVARCHAR, @id_doc_type)
                        END + CASE WHEN @agr_type IS NULL THEN ''
                                   ELSE ' @agr_type='
                                        + CONVERT(NVARCHAR, @agr_type)
                              END + CASE WHEN @doc_type IS NULL THEN ''
                                         ELSE ' @doc_type='
                                              + CONVERT(NVARCHAR, @doc_type)
                                    END + CASE WHEN @descr IS NULL THEN ''
                                               ELSE ' @descr='
                                                    + CONVERT(NVARCHAR, @descr)
                                          END
                + CASE WHEN @available IS NULL THEN ''
                       ELSE ' @available=' + CONVERT(NVARCHAR, @available)
                  END + CASE WHEN @id_matchers2schemes IS NULL THEN ''
                             ELSE ' @id_matchers2schemes='
                                  + CONVERT(NVARCHAR, @id_matchers2schemes)
                        END + CASE WHEN @id_document IS NULL THEN ''
                                   ELSE ' @id_document='
                                        + CONVERT(NVARCHAR, @id_document)
                              END + CASE WHEN @add_docs IS NULL THEN ''
                                         ELSE ' @add_docs='
                                              + CONVERT(NVARCHAR(MAX), @add_docs)
                                    END + CASE WHEN @id_parent IS NULL THEN ''
                                               ELSE ' @id_parent='
                                                    + CONVERT(NVARCHAR(MAX), @id_parent)
                                          END
                + CASE WHEN @is_electron IS NULL THEN ''
                       ELSE ' @is_electron='
                            + CONVERT(NVARCHAR(MAX), @is_electron)
                  END

        EXEC sk_log @action = 'insLog', @proc_name = 'sk_agreements',
            @id_program = @id_program, @params = @log_params

	--=================================
	--Документы (agr_documents)
	--=================================														
        IF @action = 'insDocument'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                INSERT  INTO [agr_documents]
                        ( [id_doc_type] ,
                          [number] ,
                          [reg_number] ,
                          [doc_date] ,
                          contract_num ,
                          contract_date ,
                          [id_department] ,
                          [id_contract_type] ,
                          [id_company] ,
                          [id_contractor] ,
                          [amount] ,
                          [id_doc_manager] ,
                          [dattim1] ,
                          [dattim2] ,
                          [enabled] ,
                          [id_creator] ,
                          add_docs ,
                          [old_id_document]
			            )
                VALUES  ( @id_doc_type ,
                          @number ,
                          @reg_number ,
                          @doc_date ,
                          @contract_num ,
                          @contract_date ,
                          @id_department ,
                          @id_contract_type ,
                          @id_company ,
                          @id_contractor ,
                          @amount ,
                          @id_doc_manager ,
                          GETDATE() ,
                          '3.3.3333' ,
                          1 ,
                          @id_creator ,
                          @add_docs ,
                          NULL
			            )

                SELECT  @id_document = @@IDENTITY

                RETURN @id_document
            END
        ELSE
            IF @action = 'updDocument'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    INSERT  INTO [agr_documents]
                            ( [id_doc_type] ,
                              [number] ,
                              [reg_number] ,
                              [doc_date] ,
                              contract_num ,
                              contract_date ,
                              [id_department] ,
                              [id_contract_type] ,
                              [id_company] ,
                              [id_contractor] ,
                              [amount] ,
                              [id_doc_manager] ,
                              [dattim1] ,
                              [dattim2] ,
                              [enabled] ,
                              [id_creator] ,
                              add_docs ,
                              [old_id_document]
				            )
                            SELECT  [id_doc_type] ,
                                    [number] ,
                                    [reg_number] ,
                                    [doc_date] ,
                                    contract_num ,
                                    contract_date ,
                                    [id_department] ,
                                    [id_contract_type] ,
                                    [id_company] ,
                                    [id_contractor] ,
                                    [amount] ,
                                    [id_doc_manager] ,
                                    [dattim1] ,
                                    GETDATE() ,
                                    0 ,
                                    [id_creator] ,
                                    add_docs ,
                                    [id_document]
                            FROM    agr_documents d
                            WHERE   d.id_document = @id_document

                    IF @id_doc_type IS NULL
                        BEGIN
                            SELECT  @id_doc_type = id_doc_type
                            FROM    agr_documents
                            WHERE   id_document = @id_document
                        END

                    IF @number IS NULL
                        BEGIN
                            SELECT  @number = number
                            FROM    agr_documents
                            WHERE   id_document = @id_document
                        END

                    IF @reg_number IS NULL
                        BEGIN
                            SELECT  @reg_number = reg_number
                            FROM    agr_documents
                            WHERE   id_document = @id_document
                        END

                    IF @doc_date IS NULL
                        BEGIN
                            SELECT  @doc_date = doc_date
                            FROM    agr_documents
                            WHERE   id_document = @id_document
                        END

                    IF @contract_num IS NULL
                        BEGIN
                            SELECT  @contract_num = contract_num
                            FROM    agr_documents
                            WHERE   id_document = @id_document
                        END

                    IF @contract_date IS NULL
                        BEGIN
                            SELECT  @contract_date = contract_date
                            FROM    agr_documents
                            WHERE   id_document = @id_document
                        END

                    IF @id_department IS NULL
                        BEGIN
                            SELECT  @id_department = id_department
                            FROM    agr_documents
                            WHERE   id_document = @id_document
                        END

                    IF @id_contract_type IS NULL
                        BEGIN
                            SELECT  @id_contract_type = id_contract_type
                            FROM    agr_documents
                            WHERE   id_document = @id_document
                        END

                    IF @id_company IS NULL
                        BEGIN
                            SELECT  @id_company = id_company
                            FROM    agr_documents
                            WHERE   id_document = @id_document
                        END

                    IF @id_contractor IS NULL
                        BEGIN
                            SELECT  @id_contractor = id_contractor
                            FROM    agr_documents
                            WHERE   id_document = @id_document
                        END

                    IF @amount IS NULL
                        BEGIN
                            SELECT  @amount = amount
                            FROM    agr_documents
                            WHERE   id_document = @id_document
                        END

                    IF @id_doc_manager IS NULL
                        BEGIN
                            SELECT  @id_doc_manager = id_doc_manager
                            FROM    agr_documents
                            WHERE   id_document = @id_document
                        END

                    IF @id_creator IS NULL
                        BEGIN
                            SELECT  @id_creator = id_creator
                            FROM    agr_documents
                            WHERE   id_document = @id_document
                        END

                    IF @id_creator IS NULL
                        BEGIN
                            SELECT  @add_docs = add_docs
                            FROM    agr_documents
                            WHERE   id_document = @id_document
                        END
			
                    UPDATE  agr_documents
                    SET     [id_doc_type] = @id_doc_type ,
                            [number] = @number ,
                            [reg_number] = @reg_number ,
                            [doc_date] = @doc_date ,
                            contract_num = @contract_num ,
                            contract_date = @contract_date ,
                            [id_department] = @id_department ,
                            [id_contract_type] = @id_contract_type ,
                            [id_company] = @id_company ,
                            [id_contractor] = @id_contractor ,
                            [amount] = @amount ,
                            [id_doc_manager] = @id_doc_manager ,
                            [id_creator] = @id_creator ,
                            add_docs = @add_docs
                    WHERE   id_document = @id_document
                END
            ELSE
                IF @action = 'closeDocument'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END

                        UPDATE  agr_documents
                        SET     enabled = 0 ,
                                dattim2 = GETDATE() ,
                                id_creator = @id_creator
                        WHERE   id_document = @id_document
                    END

	--=================================
	--Схемы согласования
	--=================================
        IF @action = 'insScheme'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                IF @amount1 IS NULL
                    BEGIN
                        SET @amount1 = 0
                    END

                IF @amount2 IS NULL
                    BEGIN
                        SET @amount2 = 0
                    END

                INSERT  INTO [agr_schemes]
                        ( [name] ,
                          [enabled] ,
                          [dattim1] ,
                          [dattim2] ,
                          [id_department] ,
                          [id_contract_type] ,
                          [amount1] ,
                          [amount2] ,
                          [old_id_agr_scheme] ,
                          [id_creator] ,
                          [matchers_notice] ,
                          id_agr_scheme_type
			            )
                VALUES  ( @name ,
                          1 ,
                          GETDATE() ,
                          '3.3.3333' ,
                          @id_department ,
                          @id_contract_type ,
                          @amount1 ,
                          @amount2 ,
                          NULL ,
                          @id_creator ,
                          @matchers_notice ,
                          @id_agr_scheme_type
			            )
            END
        ELSE
            IF @action = 'updScheme'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    INSERT  INTO agr_schemes
                            ( [name] ,
                              [enabled] ,
                              [dattim2] ,
                              [dattim1] ,
                              [id_department] ,
                              [id_contract_type] ,
                              [amount1] ,
                              [amount2] ,
                              id_creator ,
                              [old_id_agr_scheme] ,
                              matchers_notice ,
                              id_agr_scheme_type
				            )
                            SELECT  [name] ,
                                    0 ,
                                    GETDATE() ,
                                    dattim1 ,
                                    [id_department] ,
                                    [id_contract_type] ,
                                    [amount1] ,
                                    [amount2] ,
                                    id_creator ,
                                    id_agr_scheme ,
                                    matchers_notice ,
                                    id_agr_scheme_type
                            FROM    agr_schemes s
                            WHERE   s.id_agr_scheme = @id_agr_scheme

                    IF @name IS NULL
                        BEGIN
                            SELECT  @name = NAME
                            FROM    agr_schemes
                            WHERE   id_agr_scheme = @id_agr_scheme
                        END

                    IF @id_department IS NULL
                        BEGIN
                            SELECT  @id_department = id_department
                            FROM    agr_schemes
                            WHERE   id_agr_scheme = @id_agr_scheme
                        END

                    IF @id_contract_type IS NULL
                        BEGIN
                            SELECT  @id_contract_type = id_contract_type
                            FROM    agr_schemes
                            WHERE   id_agr_scheme = @id_agr_scheme
                        END

                    IF @amount1 IS NULL
                        BEGIN
                            SELECT  @amount1 = amount1
                            FROM    agr_schemes
                            WHERE   id_agr_scheme = @id_agr_scheme
                        END

                    IF @amount2 IS NULL
                        BEGIN
                            SELECT  @amount2 = amount2
                            FROM    agr_schemes
                            WHERE   id_agr_scheme = @id_agr_scheme
                        END

                    IF @id_creator IS NULL
                        BEGIN
                            SELECT  @id_creator = id_creator
                            FROM    agr_schemes
                            WHERE   id_agr_scheme = @id_agr_scheme
                        END
			
                    IF @matchers_notice IS NULL
                        BEGIN
                            SELECT  @matchers_notice = matchers_notice
                            FROM    agr_schemes
                            WHERE   id_agr_scheme = @id_agr_scheme
                        END		
			
                    IF @id_agr_scheme_type IS NULL
                        BEGIN
                            SELECT  @id_agr_scheme_type = id_agr_scheme_type
                            FROM    agr_schemes
                            WHERE   id_agr_scheme = @id_agr_scheme
                        END			

                    UPDATE  agr_schemes
                    SET     [name] = @name ,
                            [id_department] = @id_department ,
                            [id_contract_type] = @id_contract_type ,
                            [amount1] = @amount1 ,
                            [amount2] = @amount2 ,
                            id_creator = @id_creator ,
                            matchers_notice = @matchers_notice ,
                            id_agr_scheme_type = @id_agr_scheme_type
                    WHERE   id_agr_scheme = @id_agr_scheme
                END
            ELSE
                IF @action = 'closeSchemeById'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END

                        UPDATE  agr_schemes
                        SET     enabled = 0 ,
                                dattim2 = GETDATE() ,
                                id_creator = @id_creator
                        WHERE   id_agr_scheme = @id_agr_scheme
                    END

	--=================================
	--Согласователи в схеме
	--=================================	
        IF @action = 'insMatcher2Scheme'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                INSERT  INTO [agr_matchers2schemes]
                        ( [id_agr_matcher] ,
                          [id_agr_scheme] ,
                          [order_num] ,
                          [enabled] ,
                          [dattim1] ,
                          [dattim2] ,
                          [id_creator]
			            )
                VALUES  ( @id_agr_matcher ,
                          @id_agr_scheme ,
                          @order_num ,
                          1 ,
                          GETDATE() ,
                          '3.3.3333' ,
                          @id_creator
			            )
            END
        ELSE
            IF @action = 'updMatcher2Scheme'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    UPDATE  [agr_matchers2schemes]
                    SET     [order_num] = @order_num
                    WHERE   id_matchers2schemes = @id_matchers2schemes
                END
            ELSE
                IF @action = 'closeMatcher2SchemeById'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END

                        UPDATE  [agr_matchers2schemes]
                        SET     enabled = 0 ,
                                dattim2 = GETDATE() ,
                                id_creator = @id_creator
                        WHERE   id_matchers2schemes = @id_matchers2schemes
                    END

	--=================================
	--Согласователи
	--=================================														
        IF @action = 'insMatcher'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
							 
				
                INSERT  INTO [agr_matchers]
                        ( [id_user] ,
                          [doc_type] ,
                          [agr_type] ,
                          [descr] ,
                          [available] ,
                          [id_main_matcher] ,
                          [enabled] ,
                          [dattim1] ,
                          [dattim2] ,
                          [id_creator] ,
                          order_num
			            )
                VALUES  ( @id_user ,
                          @doc_type ,
                          @agr_type ,
                          @descr ,
                          1 ,
                          @id_main_matcher ,
                          1 ,
                          GETDATE() ,
                          '03.03.3333' ,
                          @id_creator ,
                          @order_num
			            )
            END
        ELSE
            IF @action = 'updMatcher'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    INSERT  INTO [agr_matchers]
                            ( [id_user] ,
                              [doc_type] ,
                              [agr_type] ,
                              [descr] ,
                              [available] ,
                              [id_main_matcher] ,
                              [enabled] ,
                              [dattim1] ,
                              [dattim2] ,
                              [id_creator] ,
                              order_num
				            )
                            SELECT  [id_user] ,
                                    [doc_type] ,
                                    [agr_type] ,
                                    [descr] ,
                                    [available] ,
                                    [id_main_matcher] ,
                                    0 ,
                                    [dattim1] ,
                                    GETDATE() ,
                                    [id_creator] ,
                                    order_num
                            FROM    [agr_matchers] m
                            WHERE   m.id_agr_matcher = @id_agr_matcher

                    UPDATE  [agr_matchers]
                    SET     [id_user] = @id_user ,
                            [doc_type] = @doc_type ,
                            [agr_type] = @agr_type ,
                            [descr] = @descr ,
                            [available] = @available ,
                            id_main_matcher = @id_main_matcher ,
                            [id_creator] = @id_creator ,
                            order_num = @order_num
                    WHERE   id_agr_matcher = @id_agr_matcher
                END
            ELSE
                IF @action = 'closeMatcherById'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END

                        UPDATE  agr_matchers
                        SET     enabled = 0 ,
                                dattim2 = GETDATE() ,
                                id_creator = @id_creator
                        WHERE   id_agr_matcher = @id_agr_matcher
                    END

	--=================================
	--Согласования
	--=================================														
        IF @action = 'insAgreement'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END
                    
                    SELECT @is_electron = ISNULL(@is_electron, 0)

                INSERT  INTO agr_agreements
                        ( [id_agr_scheme] ,
                          [id_agr_state] ,
                          [id_agr_manager] ,
                          id_document ,
                          [enabled] ,
                          [dattim1] ,
                          [dattim2] ,
                          [id_creator] ,
                          is_electron
			            )
                VALUES  ( @id_agr_scheme ,
                          @id_agr_state ,
                          @id_agr_manager ,
                          @id_document ,
                          1 ,
                          GETDATE() ,
                          '03.03.3333' ,
                          @id_creator ,
                          @is_electron
			            )

                SELECT  @id_agreement = @@IDENTITY

                RETURN @id_agreement
            END
        ELSE
            IF @action = 'updAgreement'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    INSERT  INTO agr_agreements
                            ( [id_agr_scheme] ,
                              [id_agr_state] ,
                              [id_agr_manager] ,
                              id_document ,
                              [enabled] ,
                              [dattim1] ,
                              [dattim2] ,
                              [id_creator] ,
                              old_id_agreement ,
                              is_electron
				            )
                            SELECT  [id_agr_scheme] ,
                                    [id_agr_state] ,
                                    [id_agr_manager] ,
                                    id_document ,
                                    0 ,
                                    [dattim1] ,
                                    GETDATE() ,
                                    [id_creator] ,
                                    id_agreement ,
                                    is_electron
                            FROM    agr_agreements a
                            WHERE   a.id_agreement = @id_agreement

                    SELECT  @id_agr_scheme = ISNULL(@id_agr_scheme,
                                                    ( SELECT  id_agr_scheme
                                                      FROM    agr_agreements
                                                      WHERE   id_agreement = @id_agreement
                                                    ))

                    SELECT  @id_agr_state = ISNULL(@id_agr_state,
                                                   ( SELECT id_agr_state
                                                     FROM   agr_agreements
                                                     WHERE  id_agreement = @id_agreement
                                                   ))

                    SELECT  @id_agr_manager = ISNULL(@id_agr_manager,
                                                     ( SELECT id_agr_manager
                                                       FROM   agr_agreements
                                                       WHERE  id_agreement = @id_agreement
                                                     ))

                    SELECT  @id_document = ISNULL(@id_document,
                                                  ( SELECT  id_document
                                                    FROM    agr_agreements
                                                    WHERE   id_agreement = @id_agreement
                                                  ))

                    SELECT  @id_creator = ISNULL(@id_creator,
                                                 ( SELECT   id_creator
                                                   FROM     agr_agreements
                                                   WHERE    id_agreement = @id_agreement
                                                 ))
						
                    SELECT  @is_electron = ISNULL(@is_electron,
                                                  ( SELECT  is_electron
                                                    FROM    agr_agreements
                                                    WHERE   id_agreement = @id_agreement
                                                  ))
						

                    UPDATE  agr_agreements
                    SET     [id_agr_state] = @id_agr_state ,
                            [id_agr_manager] = @id_agr_manager ,
                            id_creator = @id_creator
                    WHERE   id_agreement = @id_agreement
                END
            ELSE
                IF @action = 'closeAgreementById'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END

                        INSERT  INTO agr_agreements
                                ( [id_agr_scheme] ,
                                  [id_agr_state] ,
                                  [id_agr_manager] ,
                                  id_document ,
                                  [enabled] ,
                                  [dattim1] ,
                                  [dattim2] ,
                                  [id_creator] ,
                                  old_id_agreement
					            )
                                SELECT  [id_agr_scheme] ,
                                        [id_agr_state] ,
                                        [id_agr_manager] ,
                                        id_document ,
                                        0 ,
                                        [dattim1] ,
                                        GETDATE() ,
                                        [id_creator] ,
                                        id_agreement
                                FROM    agr_agreements a
                                WHERE   a.id_agreement = @id_agreement

                        SELECT  @id_agr_scheme = ISNULL(@id_agr_scheme,
                                                        ( SELECT
                                                              id_agr_scheme
                                                          FROM
                                                              agr_agreements
                                                          WHERE
                                                              id_agreement = @id_agreement
                                                        ))

                        SELECT  @id_agr_state = ISNULL(@id_agr_state,
                                                       ( SELECT
                                                              id_agr_state
                                                         FROM agr_agreements
                                                         WHERE
                                                              id_agreement = @id_agreement
                                                       ))

                        SELECT  @id_agr_manager = ISNULL(@id_agr_manager,
                                                         ( SELECT
                                                              id_agr_manager
                                                           FROM
                                                              agr_agreements
                                                           WHERE
                                                              id_agreement = @id_agreement
                                                         ))

                        SELECT  @id_document = ISNULL(@id_document,
                                                      ( SELECT
                                                              id_document
                                                        FROM  agr_agreements
                                                        WHERE id_agreement = @id_agreement
                                                      ))

                        SELECT  @id_creator = ISNULL(@id_creator,
                                                     ( SELECT id_creator
                                                       FROM   agr_agreements
                                                       WHERE  id_agreement = @id_agreement
                                                     ))

                        UPDATE  agr_agreements
                        SET     enabled = 0 ,
                                dattim2 = GETDATE() ,
                                id_creator = @id_creator
                        WHERE   id_agreement = @id_agreement
                    END

	--=================================
	--Процессы согласования
	--=================================														
        IF @action = 'insAgrProcess'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                IF @order_num IS NULL
                    BEGIN
                        SET @order_num = 1
                    END

                INSERT  INTO agr_processes
                        ( id_agreement ,
                          id_agr_matcher ,
                          order_num ,
                          id_agr_result ,
                          comment ,
                          date_change ,
                          dattim1 ,
                          dattim2 ,
                          enabled
			            )
                VALUES  ( @id_agreement ,
                          @id_agr_matcher ,
                          @order_num ,
                          @id_agr_result ,
                          @comment ,
                          NULL ,
                          GETDATE() ,
                          '03.03.3333' ,
                          1
			            )
            END
        ELSE
            IF @action = 'updAgrProcess'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    UPDATE  dbo.agr_processes
                    SET     id_agr_result = @id_agr_result ,
                            comment = @comment ,
                            date_change = GETDATE() ,
                            id_updater = @id_updater
                    WHERE   id_agr_process = @id_agr_process
                END

	--=================================
	--Местанахождения договора
	--=================================		
        IF @action = 'insManager2Process'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                INSERT  INTO agr_manager2agr_processes
                        ( id_agr_manager ,
                          id_agr_process ,
                          dattim1 ,
                          dattim2
			            )
                VALUES  ( @id_agr_manager ,
                          @id_agr_process ,
                          GETDATE() ,
                          '3.3.3333'
			            )
            END
        ELSE
            IF @action = 'closeManager2Process'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    UPDATE  agr_manager2agr_processes
                    SET     dattim2 = GETDATE()
                    WHERE   id_agr_process = @id_agr_process
                END

	--=================================
	--Ответ на комментарий в процессе
	--=================================		
        IF @action = 'insProcAnswer'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                INSERT  INTO agr_proc_answers
                        ( [text] ,
                          id_creator ,
                          id_agr_process ,
                          dattim1
			            )
                VALUES  ( @text ,
                          @id_creator ,
                          @id_agr_process ,
                          GETDATE()
                        )

                RETURN @@IDENTITY
            END

	--=================================
	--Скан документа
	--=================================		
        IF @action = 'insDocScan'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                INSERT  INTO [dbo].[agr_doc_scan]
                        ( [id_agreement] ,
                          [file_path] ,
                          [id_creator] ,
                          [dattim1] ,
                          [dattim2] ,
                          [enabled] ,
                          id_deleter ,
                          NAME ,
                          id_parent
			            )
                VALUES  ( @id_agreement ,
                          @file_path ,
                          @id_creator ,
                          GETDATE() ,
                          '3.3.3333' ,
                          1 ,
                          NULL ,
                          @name ,
                          NULL
			            )

                RETURN @@IDENTITY
            END
        ELSE
            IF @action = 'updDocScan'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    UPDATE  [dbo].[agr_doc_scan]
                    SET     id_parent = @id_parent
                    WHERE   id_doc_scan = @id_doc_scan		
                END
            ELSE
                IF @action = 'closeDocScan'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END

                        UPDATE  dbo.agr_doc_scan
                        SET     dattim2 = GETDATE() ,
                                id_deleter = @id_user ,
                                enabled = 0
                        WHERE   id_doc_scan = @id_doc_scan
                    END

	--=================================
	--Тип документа и опции
	--=================================	
        IF @action = 'insDocType'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                IF @order_num IS NULL
                    OR @order_num <= 0
                    BEGIN
                        SET @order_num = 50
                    END

                INSERT  INTO dbo.agr_doc_types
                        ( NAME ,
                          display_name ,
                          order_num ,
                          dattim1 ,
                          dattim2 ,
                          enabled
			            )
                VALUES  ( @name ,
                          @display_name ,
                          @order_num ,
                          GETDATE() ,
                          '3.3.3333' ,
                          1
			            )

                RETURN @@identity
            END
        ELSE
            IF @action = 'updDocType'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    IF @order_num IS NULL
                        OR @order_num <= 0
                        BEGIN
                            SET @order_num = 50
                        END

                    UPDATE  dbo.agr_doc_types
                    SET     NAME = @name ,
                            display_name = @display_name ,
                            order_num = @order_num
                    WHERE   id_doc_type = @id_doc_type
                END
            ELSE
                IF @action = 'closeDocType'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END

                        UPDATE  dbo.agr_doc_types
                        SET     dattim2 = GETDATE() ,
                                enabled = 0
                        WHERE   id_doc_type = @id_doc_type
                    END
                ELSE
                    IF @action = 'insDocType2Option'
                        BEGIN
                            IF @sp_test IS NOT NULL
                                BEGIN
                                    RETURN
                                END

                            INSERT  INTO dbo.agr_doc_type2doc_type_options
                                    ( id_doc_type ,
                                      id_doc_type_option ,
                                      NAME ,
                                      enabled
						            )
                            VALUES  ( @id_doc_type ,
                                      @id_doc_type_option ,
                                      @name ,
                                      1
						            )
                        END
                    ELSE
                        IF @action = 'updDocType2Option'
                            BEGIN
                                IF @sp_test IS NOT NULL
                                    BEGIN
                                        RETURN
                                    END

                                UPDATE  dbo.agr_doc_type2doc_type_options
                                SET     id_doc_type = @id_doc_type ,
                                        id_doc_type_option = @id_doc_type_option ,
                                        NAME = @name ,
                                        enabled = 1
                                WHERE   id_doc_type2doc_type_options = @id_dt2dto
                            END
                        ELSE
                            IF @action = 'uncloseDocType2Option'
                                BEGIN
                                    IF @sp_test IS NOT NULL
                                        BEGIN
                                            RETURN
                                        END

                                    UPDATE  dbo.agr_doc_type2doc_type_options
                                    SET     enabled = 1
                                    WHERE   id_doc_type2doc_type_options = @id_dt2dto
                                END
                            ELSE
                                IF @action = 'closeDocType2Option'
                                    BEGIN
                                        IF @sp_test IS NOT NULL
                                            BEGIN
                                                RETURN
                                            END

                                        UPDATE  dbo.agr_doc_type2doc_type_options
                                        SET     enabled = 0
                                        WHERE   id_doc_type2doc_type_options = @id_dt2dto
                                    END

	--=================================
	--Тип договора
	--=================================		
        IF @action = 'insContractType'
            BEGIN
                IF @sp_test IS NOT NULL
                    BEGIN
                        RETURN
                    END

                IF @order_num IS NULL
                    OR @order_num <= 0
                    BEGIN
                        SET @order_num = 50
                    END

                INSERT  INTO [dbo].agr_contract_types
                        ( NAME ,
                          display_name ,
                          order_num ,
                          dattim1 ,
                          dattim2 ,
                          enabled
			            )
                VALUES  ( @name ,
                          @display_name ,
                          @order_num ,
                          GETDATE() ,
                          '3.3.3333' ,
                          1
			            )

                RETURN @@identity
            END
        ELSE
            IF @action = 'updContractType'
                BEGIN
                    IF @sp_test IS NOT NULL
                        BEGIN
                            RETURN
                        END

                    IF @order_num IS NULL
                        OR @order_num <= 0
                        BEGIN
                            SET @order_num = 50
                        END

                    UPDATE  dbo.agr_contract_types
                    SET     NAME = @name ,
                            display_name = @display_name ,
                            order_num = @order_num
                    WHERE   id_contract_type = @id_contract_type
                END
            ELSE
                IF @action = 'closeContractType'
                    BEGIN
                        IF @sp_test IS NOT NULL
                            BEGIN
                                RETURN
                            END

                        UPDATE  dbo.agr_contract_types
                        SET     dattim2 = GETDATE() ,
                                enabled = 0
                        WHERE   id_contract_type = @id_contract_type
                    END
    END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[sk_agreements] TO [sqlChecker]
    AS [dbo];

