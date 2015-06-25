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
        public int EmpCount { get; set; }
        public Employee Creator { get; set; }

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
            EmpCount = Db.DbHelper.GetValueInt(row["emp_count"]);
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

        public void Save()
        {
            if (Creator == null) Creator = new Employee();
            SqlParameter pId = new SqlParameter() { ParameterName = "id", SqlValue = Id, SqlDbType = SqlDbType.Int };
            SqlParameter pName = new SqlParameter() { ParameterName = "name", SqlValue = Name, SqlDbType = SqlDbType.NVarChar };
            SqlParameter pCreatorAdSid = new SqlParameter() { ParameterName = "creator_sid", SqlValue = Creator.AdSid, SqlDbType = SqlDbType.VarChar };

            var dt = Db.Stuff.ExecuteQueryStoredProcedure("save_organization", pId, pName, pCreatorAdSid);
            if (dt.Rows.Count > 0)
            {
                int id;
                int.TryParse(dt.Rows[0]["id"].ToString(), out id);
                Id = id;
            }
        }

        public static void Close(int id)
        {
            SqlParameter pId = new SqlParameter() { ParameterName = "id", SqlValue = id, SqlDbType = SqlDbType.Int };

            int count = (int)Db.Stuff.ExecuteScalar("get_organization_link_count", pId);

            if (count == 0)
            {
                SqlParameter pIdOrg = new SqlParameter() { ParameterName = "id", SqlValue = id, SqlDbType = SqlDbType.Int };
                Db.Stuff.ExecuteStoredProcedure("close_organization", pIdOrg);
            }
            else
            {
                throw new Exception("Невозможно удалить юр. лицо так как есть привязка к сотрудникам!");
            }
        }
    }
}