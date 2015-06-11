using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace DataProvider.Helpers
{
    public partial class Db
    {
        public class Stuff
        {
            public static SqlConnection connection { get { return new SqlConnection(ConfigurationManager.ConnectionStrings["StuffConnectionString"].ConnectionString); } }

            public static void ExecuteStoredProcedure(string spName, params SqlParameter[] sqlParams)
            {
                DbHelper.ExecuteStoredProcedure(connection, spName, sqlParams);
            }

            public static DataTable ExecuteQueryStoredProcedure(string spName, params SqlParameter[] sqlParams)
            {
                DataTable dt = DbHelper.ExecuteQueryStoredProcedure(connection, spName, sqlParams);
                return dt;
            }

            public static object ExecuteScalarStoredProcedure(string spName, params SqlParameter[] sqlParams)
            {
                object result = DbHelper.ExecuteScalarStoredProcedure(connection, spName, sqlParams);
                return result;
            }
        }
    }
}