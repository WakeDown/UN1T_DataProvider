using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WcfDataProvider.Models.Stuff
{
    public class Department
    {
        public int Id { get; set; }
        public string Name { get; set; }

        public static IEnumerable<Department> GetList()
        {
            var lst = new List<Department>();

            lst.Add(new Department() { Id = 1, Name = "Dep1" });
            lst.Add(new Department() { Id = 2, Name = "Dep2" });
            lst.Add(new Department() { Id = 3, Name = "Dep3" });

            return lst;
        }
    }
}