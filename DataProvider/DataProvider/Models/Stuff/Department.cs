using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Http;
using DataProvider.Helpers;

namespace DataProvider.Models.Stuff
{
    public class Department
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public Department ParentDepartment { get; set; }
        public Employee Chief { get; set; }

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
            SqlParameter pId = new SqlParameter() { ParameterName = "id", SqlValue = Id, SqlDbType = SqlDbType.Int };
            SqlParameter pName = new SqlParameter() { ParameterName = "name", SqlValue = Name, SqlDbType = SqlDbType.NVarChar };
            SqlParameter pParentDepartment = new SqlParameter() { ParameterName = "id_parent", SqlValue = ParentDepartment.Id, SqlDbType = SqlDbType.Int };
            SqlParameter pChief = new SqlParameter() { ParameterName = "id_chief", SqlValue = Chief.Id, SqlDbType = SqlDbType.Int };

            var dt = Db.Stuff.ExecuteQueryStoredProcedure("save_department", pId, pName, pParentDepartment, pChief);
            if (dt.Rows.Count > 0)
            {
                int id;
                int.TryParse(dt.Rows[0]["id"].ToString(), out id);
                Id = id;
            }
        }

        public static IEnumerable<Department> GetList()
        {
            var dt = Db.Stuff.ExecuteQueryStoredProcedure("get_department");

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
    }
}