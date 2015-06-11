﻿using System;
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
        public class DbHelper
        {
            #region Константы

            //private static SqlConnection connection { get { return new SqlConnection(ConfigurationManager.ConnectionStrings["unitConnectionString"].ConnectionString); } }

            #endregion

            public static void ExecuteStoredProcedure(SqlConnection connection, string spName, params SqlParameter[] sqlParams)
            {
                using (var conn = connection)
                using (var cmd = new SqlCommand(spName, conn)
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = 1000
                })
                {
                    cmd.Parameters.AddRange(sqlParams);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            public static DataTable ExecuteQueryStoredProcedure(SqlConnection connection, string spName, params SqlParameter[] sqlParams)
            {
                DataTable dt = new DataTable();

                using (var conn = connection)
                using (var cmd = new SqlCommand(spName, conn)
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = 1000
                })
                {
                    cmd.Parameters.AddRange(sqlParams);
                    conn.Open();
                    dt.Load(cmd.ExecuteReader());
                }

                return dt;
            }

            public static object ExecuteScalarStoredProcedure(SqlConnection connection, string spName, params SqlParameter[] sqlParams)
            {
                object result;

                using (var conn = connection)
                using (var cmd = new SqlCommand(spName, conn)
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = 1000
                })
                {
                    cmd.Parameters.AddRange(sqlParams);
                    conn.Open();
                    result = cmd.ExecuteScalar();
                }

                return result;
            }

            public static int GetValueInt(object value)
            {
                int result = Convert.ToInt32(value);
                return result;
            }

            public static int? GetValueIntOrNull(object value)
            {
                int? result = null;
                if (value != null && !String.IsNullOrEmpty(value.ToString()))
                {
                    result = GetValueInt(value);
                }
                return result;
            }

            public static decimal? GetValueDeciamlOrNull(string value)
            {
                decimal? result = null;

                if (!String.IsNullOrEmpty(value))
                {
                    result = Convert.ToDecimal(value);
                }

                return result;
            }

            public static DateTime? GetValueDateTimeOrNull(object value)
            {
                DateTime? result = null;

                if (value != null && !String.IsNullOrEmpty(value.ToString()))
                {
                    result = Convert.ToDateTime(value);
                }

                return result;
            }

            public static bool GetValueBool(object value)
            {
                bool result = false;

                if (!String.IsNullOrEmpty(value.ToString()))
                {
                    result = Convert.ToBoolean(value);
                }

                return result;
            }
        }
    }
}