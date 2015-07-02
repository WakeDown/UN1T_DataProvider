using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Threading;
using System.Web;
using DataProvider.Helpers;
using DataProvider.Models.SpeCalc;
using DataProvider.Objects;
using Microsoft.OData.Core.UriParser.Semantic;

namespace DataProvider.Models.Stuff
{
    public class Employee:DbModel
    {
        public int Id { get; set; }
        public string AdSid { get; set; }
        public Employee Manager { get; set; }
        public string Surname { get; set; }
        public string Name { get; set; }
        public string Patronymic { get; set; }
        public string FullName { get; set; }
        public string DisplayName { get; set; }
        public Position Position { get; set; }
        public Organization Organization { get; set; }
        public string Email { get; set; }
        public string WorkNum { get; set; }
        public string MobilNum { get; set; }
        public EmpState EmpState { get; set; }
        public Department Department { get; set; }
        public City City { get; set; }
        public byte[] Photo { get; set; }
        public DateTime? DateCame { get; set; }
        public DateTime? BirthDate { get; set; }
        public bool IsChief { get; set; }
        public bool Male { get; set; }
        public bool HasAdAccount { get; set; }
        public Employee Creator { get; set; }
        public Position PositionOrg { get; set; }
        public string ExpirenceString { get; set; }
        public string AdLogin { get; set; }

        public Employee()
        {
            
        }

        public Employee(DataRow row)
        {
            FillSelf(row);
        }

        private void FillSelf(DataRow row)
        {
            Id = Db.DbHelper.GetValueInt(row["id"]);
            AdSid =  row.Table.Columns.Contains("ad_sid") ? row["ad_sid"].ToString() : String.Empty;
            Manager = new Employee() { Id = row.Table.Columns.Contains("id_manager") ? Db.DbHelper.GetValueInt(row["id_manager"]) : 0, DisplayName = row.Table.Columns.Contains("manager") ? row["manager"].ToString() : String.Empty, Email = row.Table.Columns.Contains("manager_email") ? row["manager_email"].ToString() : String.Empty };
            Surname = row.Table.Columns.Contains("surname") ? row["surname"].ToString() : String.Empty;
            Name = row.Table.Columns.Contains("name") ? row["name"].ToString() : String.Empty;
            Patronymic = row.Table.Columns.Contains("patronymic") ? row["patronymic"].ToString() : String.Empty;
            FullName = row.Table.Columns.Contains("full_name") ? row["full_name"].ToString() : String.Empty;
            DisplayName = row.Table.Columns.Contains("display_name") ? row["display_name"].ToString() : String.Empty;
            Position = new Position() { Id = row.Table.Columns.Contains("id_position") ? Db.DbHelper.GetValueInt(row["id_position"]) : 0, Name = row.Table.Columns.Contains("position") ? row["position"].ToString() : String.Empty };
            Organization = new Organization() { Id = row.Table.Columns.Contains("id_organization") ? Db.DbHelper.GetValueInt(row["id_organization"]) : 0, Name = row.Table.Columns.Contains("organization") ? row["organization"].ToString() : String.Empty };
            Email = row.Table.Columns.Contains("email") ? row["email"].ToString() : String.Empty;
            WorkNum = row.Table.Columns.Contains("work_num") ? row["work_num"].ToString() : String.Empty;
            MobilNum = row.Table.Columns.Contains("mobil_num") ? row["mobil_num"].ToString() : String.Empty;
            EmpState = new EmpState() { Id = row.Table.Columns.Contains("id_emp_state") ? Db.DbHelper.GetValueInt(row["id_emp_state"]) : 0, Name = row.Table.Columns.Contains("emp_state") ? row["emp_state"].ToString() : String.Empty };
            Department = new Department() { Id = row.Table.Columns.Contains("id_department") ? Db.DbHelper.GetValueInt(row["id_department"]) : 0, Name = row.Table.Columns.Contains("department") ? row["department"].ToString() : String.Empty };
            City = new City() { Id = row.Table.Columns.Contains("id_city") ? Db.DbHelper.GetValueInt(row["id_city"]) : 0, Name = row.Table.Columns.Contains("city") ? row["city"].ToString() : String.Empty };
            DateCame = row.Table.Columns.Contains("date_came") ? Db.DbHelper.GetValueDateTimeOrNull(row["date_came"]) : new DateTime();
            BirthDate = row.Table.Columns.Contains("birth_date") ? Db.DbHelper.GetValueDateTimeOrNull(row["birth_date"]) : new DateTime();
            Photo = row.Table.Columns.Contains("photo") ? row["photo"] == DBNull.Value ? null : Db.DbHelper.GetByteArr(row["photo"]) : null;
            IsChief = row.Table.Columns.Contains("is_chief") ? row["is_chief"].ToString().Equals("0") : false;
            Male = row.Table.Columns.Contains("male") ? row["male"].ToString().Equals("1") : true;
            PositionOrg = new Position() { Id = row.Table.Columns.Contains("id_position_org") ? Db.DbHelper.GetValueInt(row["id_position_org"]) : 0, Name = row.Table.Columns.Contains("position_org") ? row["position_org"].ToString() : String.Empty };
            HasAdAccount = row.Table.Columns.Contains("has_ad_account") ? row["has_ad_account"].ToString().Equals("1"): false;
            AdLogin = row.Table.Columns.Contains("ad_login") ? row["ad_login"].ToString() : String.Empty;
        }

        public Employee(int id, bool getPhoto = false)
        {
            SqlParameter pId = new SqlParameter() { ParameterName = "id", SqlValue = id, SqlDbType = SqlDbType.Int };
            SqlParameter pGetPhoto = new SqlParameter() { ParameterName = "get_photo", SqlValue = getPhoto, SqlDbType = SqlDbType.Bit };
            var dt = Db.Stuff.ExecuteQueryStoredProcedure("get_employee", pId, pGetPhoto);
            if (dt.Rows.Count > 0)
            {
                var row = dt.Rows[0];
                FillSelf(row);
                ExpirenceString = GetExpirenceString();
            }
        }

        public Employee(string adSid, bool getPhoto = false)
        {
            SqlParameter pId = new SqlParameter() { ParameterName = "ad_sid", SqlValue = adSid, SqlDbType = SqlDbType.VarChar };
            SqlParameter pGetPhoto = new SqlParameter() { ParameterName = "get_photo", SqlValue = getPhoto, SqlDbType = SqlDbType.Bit };
            var dt = Db.Stuff.ExecuteQueryStoredProcedure("get_employee", pId, pGetPhoto);
            if (dt.Rows.Count > 0)
            {
                var row = dt.Rows[0];
                FillSelf(row);
                ExpirenceString = GetExpirenceString();
            }
        }

        public int GetManagerId(int idDep)
        {
            var dep = new Department(idDep);
            int id = dep.Chief.Id;

            if (id == 0 && dep.ParentDepartment != null && dep.ParentDepartment.Id > 0)
            {
                id = GetManagerId(dep.ParentDepartment.Id);
            }

            return id;
        }

        internal void Save(bool isRefill = false, bool isAdSync = false)
        {
            bool isEdit = (Id == 0);
            if (String.IsNullOrEmpty(AdSid))
            {
                AdSid = "";
            }
            if (Creator == null) Creator = new Employee();
            if (Position == null) Position = new Position();
            if (Department == null) Department = new Department();
            if (Organization == null) Organization = new Organization();
            if (City==null)City=new City();
            if (PositionOrg==null)PositionOrg=new Position();
            if (Manager==null)Manager = new Employee();
            if (Department.Id != 0)
            {
                Department = new Department(Department.Id);
                if (Id != Department.Chief.Id)
                {
                    Manager = new Employee() {Id = GetManagerId(Department.Id)};
                }
                else
                {
                    var parDep = new Department(Department.Id);
                    if (parDep.ParentDepartment != null && parDep.ParentDepartment.Id > 0)
                    {
                        Manager = new Employee() {Id = GetManagerId(parDep.ParentDepartment.Id)};
                    }
                }
            }

            if (EmpState == null) EmpState = EmpState.GetStuffState();

            FullName = String.Format("{0} {1} {2}", Surname, Name, Patronymic);
            DisplayName = String.Format("{0} {1}{2}", Surname, !String.IsNullOrEmpty(Name) ? Name[0] + "." : String.Empty, !String.IsNullOrEmpty(Patronymic) ? Patronymic[0] + "." : String.Empty);

            SqlParameter pId = new SqlParameter() { ParameterName = "id", SqlValue = Id, SqlDbType = SqlDbType.Int };
            SqlParameter pAdSid = new SqlParameter() { ParameterName = "ad_sid", SqlValue = AdSid, SqlDbType = SqlDbType.VarChar };
            SqlParameter pManager = new SqlParameter() { ParameterName = "id_manager", SqlValue = Manager.Id, SqlDbType = SqlDbType.Int };
            SqlParameter pName = new SqlParameter() { ParameterName = "name", SqlValue = Name, SqlDbType = SqlDbType.NVarChar };
            SqlParameter pSurname = new SqlParameter() { ParameterName = "surname", SqlValue = Surname, SqlDbType = SqlDbType.NVarChar };
            SqlParameter pPatronymic = new SqlParameter() { ParameterName = "patronymic", SqlValue = Patronymic, SqlDbType = SqlDbType.NVarChar };
            SqlParameter pFullName = new SqlParameter() { ParameterName = "full_name", SqlValue = FullName, SqlDbType = SqlDbType.NVarChar };
            SqlParameter pDisplayName = new SqlParameter() { ParameterName = "display_name", SqlValue = DisplayName, SqlDbType = SqlDbType.NVarChar };
            SqlParameter pPosition = new SqlParameter() { ParameterName = "id_position", SqlValue = Position.Id, SqlDbType = SqlDbType.Int };
            SqlParameter pDepartment = new SqlParameter() { ParameterName = "id_department", SqlValue = Department.Id, SqlDbType = SqlDbType.Int };
            SqlParameter pOrganization = new SqlParameter() { ParameterName = "id_organization", SqlValue = Organization.Id, SqlDbType = SqlDbType.Int };
            SqlParameter pEmail = new SqlParameter() { ParameterName = "email", SqlValue = Email, SqlDbType = SqlDbType.NVarChar };
            SqlParameter pWorkNum = new SqlParameter() { ParameterName = "work_num", SqlValue = WorkNum, SqlDbType = SqlDbType.NVarChar };
            SqlParameter pMobilNum = new SqlParameter() { ParameterName = "mobil_num", SqlValue = MobilNum, SqlDbType = SqlDbType.NVarChar };
            SqlParameter pEmpState = new SqlParameter() { ParameterName = "id_emp_state", SqlValue = EmpState.Id, SqlDbType = SqlDbType.Int };
            SqlParameter pCity = new SqlParameter() { ParameterName = "id_city", SqlValue = City.Id, SqlDbType = SqlDbType.Int };
            SqlParameter pDateCame = new SqlParameter() { ParameterName = "date_came", SqlValue = DateCame, SqlDbType = SqlDbType.Date };
            SqlParameter pBirthDate = new SqlParameter() { ParameterName = "birth_date", SqlValue = BirthDate, SqlDbType = SqlDbType.Date };
            SqlParameter pMale = new SqlParameter() { ParameterName = "male", SqlValue = Male, SqlDbType = SqlDbType.Bit };
            SqlParameter pPositionOrg = new SqlParameter() { ParameterName = "id_position_org", SqlValue = PositionOrg.Id, SqlDbType = SqlDbType.Int };
            SqlParameter pHasAdAccount = new SqlParameter() { ParameterName = "has_ad_account", SqlValue = HasAdAccount, SqlDbType = SqlDbType.Bit };
            SqlParameter pCreatorAdSid = new SqlParameter() { ParameterName = "creator_sid", SqlValue = CurUserAdSid, SqlDbType = SqlDbType.VarChar };

            using (var conn = Db.Stuff.connection)
            {
                conn.Open();
                using (SqlTransaction tran = conn.BeginTransaction())
                {
                    try
                    {
                        var dt = Db.Stuff.ExecuteQueryStoredProcedure("save_employee", conn, tran, pId, pAdSid, pManager, pName,
                                pSurname,
                                pPatronymic, pFullName, pDisplayName, pPosition, pDepartment, pOrganization, pEmail,
                                pWorkNum,
                                pMobilNum, pEmpState, pCity, pDateCame, pBirthDate, pMale, pPositionOrg, pHasAdAccount, pCreatorAdSid);

                        if (dt.Rows.Count > 0)
                        {
                            int id;
                            int.TryParse(dt.Rows[0]["id"].ToString(), out id);
                            Id = id;
                        }

                        if (Photo != null && Photo.Count() > 0)
                        {
                            SqlParameter pIdEmployee = new SqlParameter()
                            {
                                ParameterName = "id_employee",
                                SqlValue = Id,
                                SqlDbType = SqlDbType.Int
                            };
                            SqlParameter pPicture = new SqlParameter()
                            {
                                ParameterName = "picture",
                                SqlValue = Photo,
                                SqlDbType = SqlDbType.Image
                            };
                            Db.Stuff.ExecuteQueryStoredProcedure("save_photo", conn, tran, pIdEmployee, pPicture);
                        }

                        tran.Commit();
                    }
                    catch (Exception ex)
                    {
                        tran.Rollback();
                        throw;
                    }

                }
                conn.Close();
            }

            if (HasAdAccount && !isAdSync)
            {
                Employee e = new Employee(Id);
                bool adCreate;
                try
                {
                    string sid = AdHelper.SaveUser(ref e);
                    //if (String.IsNullOrEmpty(AdSid) || AdSid != sid)
                    //{
                        //var em = new Employee(Id);
                        if (String.IsNullOrEmpty(e.AdSid) || e.AdSid != sid)
                        {
                            e.AdSid = sid;
                            e.Save(isAdSync: true);
                        }
                    //}
                    AdSid = sid;
                    adCreate = true;
                }
                catch (Exception ex)
                {
                    adCreate = false;
                    string body = String.Format("<p>Не удалось создать/обновить пользователя в Active Directory по причине:</p><p>{0}</p>", ex.Message);
                    MessageHelper.SendMailSmtp("Active Directory ERROR", body, true, Settings.Emails4SysError);
                    //throw new Exception(String.Format("Не удалось создать пользователя в Active Directory по причине - {0}", ex.Message));
                }

                if (!isRefill && isEdit)
                {
                    string body = String.Format("<p>В систему введен новый сотрудник.</p><p>{0}</p><p>{1}</p><p>{2}</p>", FullName, Email,
                        City.Name);
                    if (!adCreate) body += "<p style='color:red; font-size: 14pt;'>Не удалось создать пользователя в AD!</p>";
                    var recipients = AdHelper.GetRecipientsFromAdGroup(AdGroup.NewEmployeeNote); //Settings.Emails4NewEmployee;//
                    MessageHelper.SendMailSmtp("Новый сотрудник", body, true, recipients);//Оповещение сисадмину
                }
            }

            
        }

        public static IEnumerable<Employee> GetList(int? idDepartment = null, bool getPhoto = false)
        {
            SqlParameter pIdDepartment = new SqlParameter() { ParameterName = "id_department", SqlValue = idDepartment, SqlDbType = SqlDbType.Int };
            SqlParameter pGetPhoto = new SqlParameter() { ParameterName = "get_photo", SqlValue = getPhoto, SqlDbType = SqlDbType.Bit };
            var dt = Db.Stuff.ExecuteQueryStoredProcedure("get_employee_list", pIdDepartment, pGetPhoto);

            var lst = new List<Employee>();

            foreach (DataRow row in dt.Rows)
            {
                var emp = new Employee(row);
                lst.Add(emp);
            }

            return lst;
        }

        public static void Close(int id)
        {
            SqlParameter pId = new SqlParameter() { ParameterName = "id", SqlValue = id, SqlDbType = SqlDbType.Int };
            Db.Stuff.ExecuteStoredProcedure("close_employee", pId);
        }

        public static void SetStateFired(int id)
        {
            SqlParameter pId = new SqlParameter() { ParameterName = "id_employee", SqlValue = id, SqlDbType = SqlDbType.Int };
            SqlParameter pIdEmpState = new SqlParameter() { ParameterName = "id_emp_state", SqlValue = EmpState.GetFiredState().Id, SqlDbType = SqlDbType.Int };
            Db.Stuff.ExecuteStoredProcedure("set_employee_state", pId, pIdEmpState);
        }

        public static void SetStateDecree(int id)
        {
            SqlParameter pId = new SqlParameter() { ParameterName = "id_employee", SqlValue = id, SqlDbType = SqlDbType.Int };
            SqlParameter pIdEmpState = new SqlParameter() { ParameterName = "id_emp_state", SqlValue = EmpState.GetDecreeState().Id, SqlDbType = SqlDbType.Int };
            Db.Stuff.ExecuteStoredProcedure("set_employee_state", pId, pIdEmpState);
        }

        public static IEnumerable<string> GetFullRecipientList()
        {
            List<string> result = new List<string>();
            foreach (Employee emp in GetList())
            {
                if (!String.IsNullOrEmpty(emp.Email))result.Add(emp.Email);
            }
            return result;
        }

        public static IEnumerable<Employee> GetDayBirthdayList(DateTime day)
        {
            SqlParameter pDay = new SqlParameter() { ParameterName = "day", SqlValue = day, SqlDbType = SqlDbType.Date };
            var dt = Db.Stuff.ExecuteQueryStoredProcedure("get_employees_birthday", pDay);

            var lst = new List<Employee>();

            foreach (DataRow row in dt.Rows)
            {
                var emp = new Employee(row);
                lst.Add(emp);
            }

            return lst;
        }

        public static IEnumerable<Employee> GetMonthBirthdayList(int month)
        {
            SqlParameter pMonth = new SqlParameter() { ParameterName = "month", SqlValue = month, SqlDbType = SqlDbType.Int };
            var dt = Db.Stuff.ExecuteQueryStoredProcedure("get_employees_birthday", pMonth);

            var lst = new List<Employee>();

            foreach (DataRow row in dt.Rows)
            {
                var emp = new Employee(row);
                lst.Add(emp);
            }

            return lst;
        }

        public string GetExpirenceString()
        {
            string result=String.Empty;
            int? exp = null;
            int expYears = 0;
            int expMonths = 0;
            if (DateCame.HasValue)
            {
                exp= Math.Abs((DateCame.Value.Month - DateTime.Now.Month) + 12 * (DateCame.Value.Year - DateTime.Now.Year));
                expYears = exp.Value/12;
                expMonths = exp.Value% 12;
                int fYeDig = expYears%10;
                string y = expYears > 0 ? fYeDig >= 1 && fYeDig <= 4 && fYeDig != 11 && fYeDig != 12 && fYeDig != 13 && fYeDig != 14 ? "г." : "л." : String.Empty;
                result = String.Format("{0} {2} {1} {3}", expYears > 0 ? expYears.ToString() : String.Empty, expMonths > 0 ? expMonths.ToString() : String.Empty, y,
                    expMonths > 0 ? "м." : String.Empty);
            }

            return result;
        }

        internal static void RefillManager()
        {
            foreach (Employee emp in GetList())
            {
                emp.Save(true);
            }
        }

        public static IEnumerable<Employee> GetNewbieList(DateTime dateCreate)
        {
            SqlParameter pDateCreate = new SqlParameter() { ParameterName = "date_came", SqlValue = dateCreate, SqlDbType = SqlDbType.Date };
            var dt = Db.Stuff.ExecuteQueryStoredProcedure("get_employees_newbie", pDateCreate);

            var lst = new List<Employee>();

            foreach (DataRow row in dt.Rows)
            {
                var emp = new Employee(row);
                lst.Add(emp);
            }

            return lst;
        }

        public static IEnumerable<Employee> GetFiredList(int? idDepartment = null)
        {
            SqlParameter pIdEmpState = new SqlParameter() { ParameterName = "id_emp_state", SqlValue = EmpState.GetFiredState().Id, SqlDbType = SqlDbType.Int };
            SqlParameter pIdDepartment = new SqlParameter() { ParameterName = "id_department", SqlValue = idDepartment, SqlDbType = SqlDbType.Int };
            var dt = Db.Stuff.ExecuteQueryStoredProcedure("get_other_employee_list", pIdEmpState, pIdDepartment);

            var lst = new List<Employee>();

            foreach (DataRow row in dt.Rows)
            {
                var emp = new Employee(row);
                lst.Add(emp);
            }

            return lst;
        }

        public static IEnumerable<Employee> GetDecreeList(int? idDepartment = null)
        {
            SqlParameter pIdEmpState = new SqlParameter() { ParameterName = "id_emp_state", SqlValue = EmpState.GetDecreeState().Id, SqlDbType = SqlDbType.Int };
            SqlParameter pIdDepartment = new SqlParameter() { ParameterName = "id_department", SqlValue = idDepartment, SqlDbType = SqlDbType.Int };
            var dt = Db.Stuff.ExecuteQueryStoredProcedure("get_other_employee_list", pIdEmpState, pIdDepartment);

            var lst = new List<Employee>();

            foreach (DataRow row in dt.Rows)
            {
                var emp = new Employee(row);
                lst.Add(emp);
            }

            return lst;
        }
    }
}