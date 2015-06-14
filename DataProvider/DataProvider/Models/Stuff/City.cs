using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using DataProvider.Helpers;

namespace DataProvider.Models.Stuff
{
    public class City
    {
        public int Id { get; set; }
        public string Name { get; set; }

        public City()
        {
        }

        public City(DataRow row)
        {
            FillSelf(row);
        }

         public City(int id)
        {
            SqlParameter pId = new SqlParameter() { ParameterName = "id", SqlValue = id, SqlDbType = SqlDbType.Int };
            var dt = Db.Stuff.ExecuteQueryStoredProcedure("get_city", pId);
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

        public static IEnumerable<City> GetList()
        {
            var dt = Db.Stuff.ExecuteQueryStoredProcedure("get_city");
            var lst = new List<City>();
            foreach (DataRow row in dt.Rows)
            {
                var city = new City(row);
                lst.Add(city);
            }
            return lst;
        }
    }
}