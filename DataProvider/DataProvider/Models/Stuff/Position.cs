using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using DataProvider.Helpers;

namespace DataProvider.Models.Stuff
{
    public class Position
    {
        public int Id { get; set; }
        public string Name { get; set; }

        public Position()
        {
        }

        public Position(DataRow row)
        {
            FillSelf(row);
        }

        public Position(int id)
        {
            SqlParameter pId = new SqlParameter() { ParameterName = "id", SqlValue = id, SqlDbType = SqlDbType.Int };
            var dt = Db.Stuff.ExecuteQueryStoredProcedure("get_position", pId);
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

        public static IEnumerable<Position> GetList()
        {
            var dt = Db.Stuff.ExecuteQueryStoredProcedure("get_position");
            var lst = new List<Position>();
            foreach (DataRow row in dt.Rows)
            {
                var pos = new Position(row);
                lst.Add(pos);
            }
            return lst;
        }
    }

    
}