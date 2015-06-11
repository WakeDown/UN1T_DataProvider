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
    public class DepartmentController : ApiController
    {
        [EnableQuery]
        public IQueryable<Department> GetList()
        {
            return new EnumerableQuery<Department>(Department.GetList());
        }

        public Department Get(int id)
        {
            var dep = new Department(id);
            return dep;
        }

        public HttpResponseMessage Save(Department dep)
        {
            HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.Created);

            try
            {
                //throw new Exception("Test server exception");
            }
            catch (Exception ex)
            {
                response = new HttpResponseMessage(HttpStatusCode.BadRequest);
                response.Content = new StringContent(ex.Message);

            }
            return response;


            //if (String.IsNullOrEmpty(model.Title))
            //    return new HttpResponseMessage(HttpStatusCode.BadRequest);

            ///*Логика сохранения*/

            //return new HttpResponseMessage(HttpStatusCode.Created);
        }
    }
}
