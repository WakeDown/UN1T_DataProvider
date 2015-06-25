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
using Microsoft.OData.Core.UriParser.Semantic;

namespace DataProvider.Models.Stuff
{
    public class Employee
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

        /// <summary>
        /// Официальная должность
        /// </summary>
        public Position PositionOrg { get; set; }
        public string ExpirenceString { get; set; }

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
            AdSid = row["ad_sid"].ToString();
            Manager = new Employee() { Id = Db.DbHelper.GetValueInt(row["id_manager"]), DisplayName = row["manager"].ToString(), Email = row["manager_email"].ToString() };
            Surname = row["surname"].ToString();
            Name = row["name"].ToString();
            Patronymic = row["patronymic"].ToString();
            FullName = row["full_name"].ToString();
            DisplayName = row["display_name"].ToString();
            Position = new Position() { Id = Db.DbHelper.GetValueInt(row["id_position"]), Name = row["position"].ToString() };
            Organization = new Organization() { Id = Db.DbHelper.GetValueInt(row["id_organization"]), Name = row["organization"].ToString() };
            Email = row["email"].ToString();
            WorkNum = row["work_num"].ToString();
            MobilNum = row["mobil_num"].ToString();
            EmpState = new EmpState() { Id = Db.DbHelper.GetValueInt(row["id_emp_state"]), Name = row["emp_state"].ToString() };
            Department = new Department() { Id = Db.DbHelper.GetValueInt(row["id_department"]), Name = row["department"].ToString() };
            City = new City() { Id = Db.DbHelper.GetValueInt(row["id_city"]), Name = row["city"].ToString() };
            DateCame = Db.DbHelper.GetValueDateTimeOrNull(row["date_came"]);
            BirthDate = Db.DbHelper.GetValueDateTimeOrNull(row["birth_date"]);
            Photo = row.Table.Columns.Contains("photo") ? row["photo"] == DBNull.Value ? null : Db.DbHelper.GetByteArr(row["photo"]) : null;
            IsChief = row.Table.Columns.Contains("is_chief") ? row["is_chief"].ToString().Equals("0") : false;
            Male = row["male"].ToString().Equals("1");
            PositionOrg = new Position() { Id = Db.DbHelper.GetValueInt(row["id_position_org"]), Name = row["position_org"].ToString() };
            HasAdAccount = row["has_ad_account"].ToString().Equals("1");
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

        internal void Save()
        {
            if (String.IsNullOrEmpty(AdSid))
            {
                AdSid = "";
            }
            if (Manager == null)
            {
                try
                {
                    Manager = new Employee() { Id = new Department(Department.Id).Chief.Id };
                }
                catch (Exception)
                {
                    Manager = new Employee();
                }
            }

            if (EmpState == null) EmpState = EmpState.GetStuffState();

            FullName = String.Format("{0} {1} {2}", Surname, Name, Patronymic);
            DisplayName = String.Format("{0} {1}{2}", Surname, !String.IsNullOrEmpty(Name) ? Name[0] + "." : String.Empty, !String.IsNullOrEmpty(Patronymic) ? Patronymic[0] + "." : String.Empty);
            if (Creator==null)Creator=new Employee();

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
            SqlParameter pCreatorAdSid = new SqlParameter() { ParameterName = "creator_sid", SqlValue = Creator.AdSid, SqlDbType = SqlDbType.VarChar };

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
        }

        public static IEnumerable<Employee> GetList(int? idDepartment = null, bool getPhoto = false)
        {
            SqlParameter pIdDepartment = new SqlParameter() { ParameterName = "id_department", SqlValue = idDepartment, SqlDbType = SqlDbType.Int };
            SqlParameter pGetPhoto = new SqlParameter() { ParameterName = "get_photo", SqlValue = getPhoto, SqlDbType = SqlDbType.Bit };
            var dt = Db.Stuff.ExecuteQueryStoredProcedure("get_employee", pIdDepartment, pGetPhoto);

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
            var dt = Db.Stuff.ExecuteQueryStoredProcedure("close_employee", pId);
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
    }
}