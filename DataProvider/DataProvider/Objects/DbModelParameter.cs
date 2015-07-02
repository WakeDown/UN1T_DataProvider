using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataProvider.Objects
{
    public class DbModelParameter<T> where T:class
    {
        public T Value;
        public string DbName;
        public SqlDbType DbType;

        public DbModelParameter(String dbName, SqlDbType dbType)
        {
            DbName = dbName;
            DbType = dbType;
        }
    }
}
