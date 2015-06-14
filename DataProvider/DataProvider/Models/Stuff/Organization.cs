using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using DataProvider.Helpers;

namespace DataProvider.Models.Stuff
{
    public class Organization
    {
        public int Id { get; set; }
        public string Name { get; set; }

        public Organization()
        {
        }

        public Organization(DataRow row)
        {
            FillSelf(row);
        }

        public Organization(int id)
        {
            SqlParameter pId = new SqlParameter() { ParameterName = "id", SqlValue = id, SqlDbType = SqlDbType.Int };
            var dt = Db.Stuff.ExecuteQueryStoredProcedure("get_organization", pId);
            if (dt.Rows.Count > 0)
            {
                var row = dt.Rows[0];
                FillSelf(row);
            }
        }

        private void FillSelf(DataRow row)
        {
            Id = Db.DbHelper.GetValueInt(row["id"]);
            Name = row["name"].ToString();
        }

        public static IEnumerable<Organization> GetList()
        {
            var dt = Db.Stuff.ExecuteQueryStoredProcedure("get_organization");
            var lst = new List<Organization>();
            foreach (DataRow row in dt.Rows)
            {
                var org = new Organization(row);
                lst.Add(org);
            }
            return lst;
        }

        
    }
}