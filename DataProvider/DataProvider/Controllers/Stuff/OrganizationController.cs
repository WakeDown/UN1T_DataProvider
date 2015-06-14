using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.OData;
using DataProvider.Models.Stuff;

namespace DataProvider.Controllers.Stuff
{
    public class OrganizationController : ApiController
    {
        [EnableQuery]
        public IQueryable<Organization> GetList()
        {
            return new EnumerableQuery<Organization>(Organization.GetList());
        }

        public Organization Get(int id)
        {
            var model = new Organization(id);
            return model;
        }
    }
}
