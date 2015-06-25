﻿using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Http.ModelBinding.Binders;

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

            public static void ExecuteStoredProcedure(SqlConnection connection, SqlTransaction tran, string spName, params SqlParameter[] sqlParams)
            {
                using (var conn = connection)
                using (var cmd = new SqlCommand(spName, conn)
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = 1000,
                    Transaction = tran
                })
                {
                    cmd.Parameters.AddRange(sqlParams);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            public static DataTable ExecuteQueryStoredProcedure(SqlConnection connection, SqlTransaction tran, string spName, params SqlParameter[] sqlParams)
            {
                DataTable dt = new DataTable();

                using (var cmd = new SqlCommand(spName, connection, tran)
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = 1000
                })
                {
                    cmd.Parameters.AddRange(sqlParams);
                    dt.Load(cmd.ExecuteReader());
                }

                return dt;
            }

            public static object ExecuteScalar(SqlConnection connection, string spName, params SqlParameter[] sqlParams)
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

            public static int GetValueIntOrDefault(object value)
            {
                int? result = GetValueIntOrNull(value);
                return result ?? 0;
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

            public static DateTime GetValueDateTime(object value)
            {
                DateTime result = Convert.ToDateTime(value);
                return result;
            }

            public static DateTime? GetValueDateTimeOrNull(object value)
            {
                DateTime? result = null;

                if (value != null && !String.IsNullOrEmpty(value.ToString()))
                {
                    result = GetValueDateTime(value);
                }

                return result;
            }

            public static bool GetValueBool(object value)
            {
                bool result = false;

                if (!String.IsNullOrEmpty(value.ToString()))
                {
                    result = value.ToString().Equals("1");
                }

                return result;
            }

            public static byte[] GetByteArr(object value)
            {
                byte[] result = null;

                try
                {
                    result = (Byte[])value;
                }
                catch (Exception ex)
                {
                    result = new byte[25];
                }

                return result;
            }
        }
    }
}