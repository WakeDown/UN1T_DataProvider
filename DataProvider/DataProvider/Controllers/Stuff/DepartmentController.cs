using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.OData;
using DataProvider.Models.Stuff;
using DataProvider.Objects;

namespace DataProvider.Controllers.Stuff
{
    public class DepartmentController : ApiController
    {
       
        [EnableQuery]
        public IQueryable<Department> GetList()
        {
            return new EnumerableQuery<Department>(Department.GetList());
        }

        public IQueryable<Department> GetOrgStructure()
        {
            return new EnumerableQuery<Department>(Department.GetOrgStructure());
        }
        
        public Department Get(int id)
        {
            var dep = new Department(id);
            return dep;
        }
        [AuthorizeAd(Groups = new[] { AdGroup.PersonalManager })]
        public HttpResponseMessage Save(Department dep)
        {
            HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.Created);

            try
            {
                dep.Save();
                response.Content = new StringContent(String.Format("{{\"id\":{0}}}", dep.Id));
            }
            catch (Exception ex)
            {
                response = new HttpResponseMessage(HttpStatusCode.OK);
                response.Content = new StringContent(String.Format("{{\"errorMessage\":\"{0}\"}}", ex.Message));

            }
            return response;
        }
        [AuthorizeAd(Groups = new[] { AdGroup.PersonalManager })]
        public HttpResponseMessage Close(int id)
        {
            HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.Created);

            try
            {
                Department.Close(id);
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
