using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.OData;
using DataProvider.Models.Stuff;

namespace DataProvider.Controllers.Stuff
{
    public class EmployeeController : ApiController
    {

        [EnableQuery]
        public IQueryable<Employee> GetList()
        {
            return new EnumerableQuery<Employee>(new Collection<Employee>() { new Employee(1), new Employee(2) });
        }
        //public ICollection<Employee> Get()
        //{
        //    return new Collection<Employee>() { new Employee(1), new Employee(2) };
        //}
        
        public Employee Get(int id)
        {
            return new Employee(id);
        }

        public string Save(Employee emp)
        {
            return "Сохранено";

            //if (String.IsNullOrEmpty(model.Title))
            //    return new HttpResponseMessage(HttpStatusCode.BadRequest);

            ///*Логика сохранения*/

            //return new HttpResponseMessage(HttpStatusCode.Created);
        }

        public string Delete(int id)
        {
            return String.Format("Топик {0} удален!", id);
        }
    }
}
