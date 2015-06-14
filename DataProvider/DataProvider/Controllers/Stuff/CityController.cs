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
    public class CityController : ApiController
    {
        [EnableQuery]
        public IQueryable<City> GetList()
        {
            return new EnumerableQuery<City>(City.GetList());
        }

        public City Get(int id)
        {
            var model = new City(id);
            return model;
        }
    }
}
