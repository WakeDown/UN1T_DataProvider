using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Http;
using DataProvider.Helpers;
using WebGrease.Css.Extensions;

namespace DataProvider.Models.Stuff
{
    public class Department
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public Department ParentDepartment { get; set; }
        public Employee Chief { get; set; }
        public int EmployeeCount { get; set; }
        public Employee Creator { get; set; }

        public IEnumerable<Department> ChildList { get; set; }
        public int OrgStructureLevel { get; set; }


        public Department() { }

        public Department(DataRow row)
        {
            FillSelf(row);
        }

        private void FillSelf(DataRow row)
        {
            Id = Db.DbHelper.GetValueInt(row["id"]);
            Name = row["name"].ToString();
            ParentDepartment = new Department() { Id = Db.DbHelper.GetValueInt(row["id_parent"]), Name = row["parent"].ToString()};
            Chief = new Employee() { Id = Db.DbHelper.GetValueInt(row["id_chief"]), DisplayName = row["chief"].ToString() };
            EmployeeCount = Db.DbHelper.GetValueIntOrDefault(row["emp_count"]);
        }

        public Department(int id)
        {
            SqlParameter pId = new SqlParameter() {ParameterName = "id", SqlValue = id,SqlDbType = SqlDbType.Int };
            var dt = Db.Stuff.ExecuteQueryStoredProcedure("get_department", pId);
            if (dt.Rows.Count > 0)
            {
                var row = dt.Rows[0];
                FillSelf(row);
            }
        }

        public void Save()
        {
            if (Creator == null) Creator = new Employee();
            SqlParameter pId = new SqlParameter() { ParameterName = "id", SqlValue = Id, SqlDbType = SqlDbType.Int };
            SqlParameter pName = new SqlParameter() { ParameterName = "name", SqlValue = Name, SqlDbType = SqlDbType.NVarChar };
            SqlParameter pParentDepartment = new SqlParameter() { ParameterName = "id_parent", SqlValue = ParentDepartment.Id, SqlDbType = SqlDbType.Int };
            SqlParameter pChief = new SqlParameter() { ParameterName = "id_chief", SqlValue = Chief.Id, SqlDbType = SqlDbType.Int };
            SqlParameter pCreatorAdSid = new SqlParameter() { ParameterName = "creator_sid", SqlValue = Creator.AdSid, SqlDbType = SqlDbType.VarChar };

            var dt = Db.Stuff.ExecuteQueryStoredProcedure("save_department", pId, pName, pParentDepartment, pChief, pCreatorAdSid);
            if (dt.Rows.Count > 0)
            {
                int id;
                int.TryParse(dt.Rows[0]["id"].ToString(), out id);
                Id = id;
            }
        }

        public static IEnumerable<Department> GetList(bool getEmpCount = false)
        {
            SqlParameter pGetEmpCount = new SqlParameter() { ParameterName = "get_emp_count", SqlValue = getEmpCount, SqlDbType = SqlDbType.Bit };
            var dt = Db.Stuff.ExecuteQueryStoredProcedure("get_department", pGetEmpCount);

            var lst = new List<Department>();

            foreach (DataRow row in dt.Rows)
            {
                var dep = new Department(row);
                lst.Add(dep);
            }

            return lst;
        }
        
        public static void Close(int id)
        {
            SqlParameter pId = new SqlParameter() { ParameterName = "id", SqlValue = id, SqlDbType = SqlDbType.Int };
            var dt = Db.Stuff.ExecuteQueryStoredProcedure("close_department", pId);
        }

        public static IEnumerable<Department> GetOrgStructure()
        {
            var deps = GetList(getEmpCount:true).ToList();
            var result = new List<Department>();

            //Отделяем подразделения без гавных
            result = deps.Where(d => d.ParentDepartment == null || d.ParentDepartment == new Department() || (d.ParentDepartment != null && d.ParentDepartment.Id == 0)).ToList();
            deps.RemoveAll(d => d.ParentDepartment == null || d.ParentDepartment == new Department());
            result.ForEach(d => d.OrgStructureLevel = 1);

            foreach (Department dep in result)
            {
                var childs = GetDepartmentChilds(dep.Id, ref deps);
                childs.ForEach(d => d.OrgStructureLevel = 2);
                dep.ChildList = childs;
            }

            foreach (Department dep in result)
            {
                dep.EmployeeCount += GetChildEmpCount(dep.ChildList);
            }

            return result;
        }

        private static int GetChildEmpCount(IEnumerable<Department> childList)
        {
            int result = 0;

            foreach (Department dep in childList)
            {
                if (dep.ChildList.Any())
                {
                    dep.EmployeeCount += GetChildEmpCount(dep.ChildList);
                }

                result += dep.EmployeeCount;
            }

            return result;
        }

        private static IEnumerable<Department> GetDepartmentChilds(int id, ref List<Department> deps)
        {
            var result = new List<Department>();
            result = deps.Where(d => d.ParentDepartment.Id == id).ToList();
            deps.RemoveAll(d => d.ParentDepartment.Id == id);

            foreach (Department dep in result)
            {
                dep.ChildList = GetDepartmentChilds(dep.Id, ref deps);
            }

            return result;
        }

        public static bool CheckUserIsChief(int idDepartment, int idEmployee)
        {
            bool result = false;
            SqlParameter pIdDepartment = new SqlParameter() { ParameterName = "id_department", SqlValue = idDepartment, SqlDbType = SqlDbType.Int };
            SqlParameter pIdEmployee = new SqlParameter() { ParameterName = "id_employee", SqlValue = idEmployee, SqlDbType = SqlDbType.Int };
            var dt = Db.Stuff.ExecuteQueryStoredProcedure("check_employee_is_chief", pIdDepartment, pIdEmployee);
            if (dt.Rows.Count > 0)
            {
                result = dt.Rows[0]["result"].ToString().Equals("1");
            }
            return result;
        }
    }
}