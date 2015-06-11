using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
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
            ParentDepartment = new Department() { Id = Db.DbHelper.GetValueInt(row["id_parent"]) };
            Chief = new Employee() { Id = Db.DbHelper.GetValueInt(row["id_chief"]) };
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

    }
}