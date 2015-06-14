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
        public IQueryable<Employee> GetList(int? idDepartment = null)
        {
            return new EnumerableQuery<Employee>(Employee.GetList(idDepartment));
        }

        public Employee Get(int id)
        {
            var dep = new Employee(id);
            return dep;
        }

        public HttpResponseMessage Save(Employee emp)
        {
            HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.Created);

            try
            {
                emp.Save();
                response.Content = new StringContent(String.Format("{{\"id\":{0}}}", emp.Id));
            }
            catch (Exception ex)
            {
                response = new HttpResponseMessage(HttpStatusCode.OK);
                response.Content = new StringContent(String.Format("{{\"errorMessage\":\"{0}\"}}", ex.Message));

            }
            return response;
        }

        public HttpResponseMessage Close(int id)
        {
            HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.Created);

            try
            {
                Employee.Close(id);
            }
            catch (Exception ex)
            {
                response = new HttpResponseMessage(HttpStatusCode.OK);
                response.Content = new StringContent(String.Format("{{\"errorMessage\":\"{0}\"}}", ex.Message));

            }
            return response;
        }
    }
}
