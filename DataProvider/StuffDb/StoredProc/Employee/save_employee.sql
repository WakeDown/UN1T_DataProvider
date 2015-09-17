CREATE PROCEDURE [dbo].[save_employee]
    @id INT = NULL ,
    @ad_sid VARCHAR(46) ,
    @id_manager INT ,
    @surname NVARCHAR(50) ,
    @name NVARCHAR(50) ,
    @patronymic NVARCHAR(50)=null ,
    @full_name NVARCHAR(150) ,
    @display_name NVARCHAR(100) ,
    @id_position INT ,
    @id_organization INT ,
    @email NVARCHAR(150) = null,
    @work_num NVARCHAR(50)  = null,
    @mobil_num NVARCHAR(50)  = null,
    @id_emp_state INT ,
    @id_department INT ,
    @id_city INT ,
    @date_came DATE =null ,
	@birth_date date= null,
	@male bit,
	@id_position_org int,
	@has_ad_account bit,
	@creator_sid varchar(46)=null,
	@date_fired date = null,
	@full_name_dat nvarchar(150) = null,
	@full_name_rod nvarchar(150) = null,
	@id_budget int = null
AS
    BEGIN
        SET NOCOUNT ON;
        IF @id IS NOT NULL
            AND @id > 0
            AND EXISTS ( SELECT 1
                         FROM   employees
                         WHERE  id = @id )
            BEGIN
			if (@full_name_dat is null or ltrim(rtrim(@full_name_dat)) = '')
			begin
				set @full_name_dat = (select full_name_dat from employees where id=@id)
			end
			if (@full_name_rod is null or ltrim(rtrim(@full_name_rod)) = '')
			begin
				set @full_name_rod = (select full_name_rod from employees where id=@id)
			end
			if (@ad_sid is null or ltrim(rtrim(@ad_sid)) = '')
			begin
				set @ad_sid = (select ad_sid from employees where id=@id)
			end
			if (@id_manager is null or @id_manager<=0)
			begin
				set @id_manager = (select id_manager from employees where id=@id)
			end
			if (@surname is null or ltrim(rtrim(@surname)) = '')
			begin
				set @surname = (select surname from employees where id=@id)
			end
			if (@name is null or ltrim(rtrim(@name)) = '')
			begin
				set @name = (select name from employees where id=@id)
			end
			if (@patronymic is null or ltrim(rtrim(@patronymic)) = '')
			begin
				set @patronymic = (select patronymic from employees where id=@id)
			end
			if (@full_name is null or ltrim(rtrim(@full_name)) = '')
			begin
				set @full_name = (select full_name from employees where id=@id)
			end
			if (@display_name is null or ltrim(rtrim(@display_name)) = '')
			begin
				set @display_name = (select display_name from employees where id=@id)
			end
			if (@id_position is null or @id_position<=0)
			begin
				set @id_position = (select id_position from employees where id=@id)
			end
			if (@id_organization is null or @id_organization<=0)
			begin
				set @id_organization = (select id_organization from employees where id=@id)
			end
			if (@email is null or ltrim(rtrim(@email)) = '')
			begin
				set @email = (select email from employees where id=@id)
			end
			if (@work_num is null or ltrim(rtrim(@work_num)) = '')
			begin
				set @work_num = (select work_num from employees where id=@id)
			end
			if (@mobil_num is null or ltrim(rtrim(@mobil_num)) = '')
			begin
				set @mobil_num = (select mobil_num from employees where id=@id)
			end
			if (@id_department is null or @id_department<=0)
			begin
				set @id_department = (select id_department from employees where id=@id)
			end
			if (@id_city is null or @id_city<=0)
			begin
				set @id_city = (select id_city from employees where id=@id)
			end
			if (@date_came is null)
			begin
				set @date_came = (select date_came from employees where id=@id)
			end
			if (@birth_date is null)
			begin
				set @birth_date = (select birth_date from employees where id=@id)
			end
			if (@male is null)
			begin
				set @male = (select male from employees where id=@id)
			end
			if (@id_position_org is null or @id_position_org<=0)
			begin
				set @id_position_org = (select id_position_org from employees where id=@id)
			end
			if (@has_ad_account is null)
			begin
				set @has_ad_account = (select has_ad_account from employees where id=@id)
			end
			if (@full_name_dat is null or ltrim(rtrim(@full_name_dat)) = '')
			begin
				set @full_name_dat = (select full_name_dat from employees where id=@id)
			end
			if (@full_name_rod is null or ltrim(rtrim(@full_name_rod)) = '')
			begin
				set @full_name_rod = (select full_name_rod from employees where id=@id)
			end
			if (@id_budget is null or @id_budget <=0)
			begin
				set @id_budget = (select id_budget from employees where id=@id)
			end

                UPDATE  employees
                SET     ad_sid = @ad_sid ,
                        id_manager = @id_manager ,
                        surname = @surname ,
                        NAME = @name ,
                        patronymic = @patronymic ,
                        full_name = @full_name ,
                        display_name = @display_name ,
                        id_position = @id_position ,
                        id_organization = @id_organization ,
                        email = @email ,
                        work_num = @work_num ,
                        mobil_num = @mobil_num ,
                        --id_emp_state = @id_emp_state ,
                        id_department = @id_department ,
                        id_city = @id_city ,
                        date_came = @date_came,
						birth_date=@birth_date,
						male=@male,
						id_position_org=@id_position_org,
						has_ad_account = @has_ad_account,
						full_name_dat = @full_name_dat,
						full_name_rod = @full_name_rod,
						id_budget = @id_budget
                WHERE   id = @id
            END
        ELSE
            BEGIN
                INSERT  INTO employees
                        ( ad_sid ,
                          id_manager ,
                          surname ,
                          name ,
                          patronymic ,
                          full_name ,
                          display_name ,
                          id_position ,
                          id_organization ,
                          email ,
                          work_num ,
                          mobil_num ,
                          id_emp_state ,
                          id_department ,
                          id_city ,
                          date_came ,
						  birth_date,
						  male,
						  id_position_org,
						  has_ad_account,
						  creator_sid,
						  full_name_dat,
						  full_name_rod,
						  id_budget
                        )
                VALUES  ( @ad_sid ,
                          @id_manager ,
                          @surname ,
                          @name ,
                          @patronymic ,
                          @full_name ,
                          @display_name ,
                          @id_position ,
                          @id_organization ,
                          @email ,
                          @work_num ,
                          @mobil_num ,
                          @id_emp_state ,
                          @id_department ,
                          @id_city ,
                          @date_came  ,
						  @birth_date,
						  @male,
						  @id_position_org,
						  @has_ad_account,
						  @creator_sid,
						  @full_name_dat,
						  @full_name_rod,
						  @id_budget
                        )

                SELECT  @id = @@IDENTITY
            END
	 
        SELECT @id AS id
    END
