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
    public class PositionController : ApiController
    {
        [EnableQuery]
        public IQueryable<Position> GetList()
        {
            return new EnumerableQuery<Position>(Position.GetList());
        }

        public Position Get(int id)
        {
            var model = new Position(id);
            return model;
        }
    }
}
