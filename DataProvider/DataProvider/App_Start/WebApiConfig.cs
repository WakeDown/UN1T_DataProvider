using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using DataProvider.Models;
using System.Web.OData.Builder;
using System.Web.OData.Extensions;
using DataProvider.Models.Stuff;

namespace DataProvider.App_Start
{
    public static class WebApiConfig
    {
        //public static void Register(HttpConfiguration config)
        //{
        //    ODataConventionModelBuilder builder = new ODataConventionModelBuilder();
        //    builder.EntitySet<Employee>("Employees");
        //    //ActionConfiguration rateProduct = builder.Entity<Product>().Action("RateProduct");
        //    //rateProduct.Parameter<int>("Rating");
        //    //rateProduct.Returns<double>();

        //    config.Routes.MapODataRoute("odata", "odata", builder.GetEdmModel());
        //}

        public static void Register(HttpConfiguration config)
        {
            // Web API configuration and services

            // Web API routes
            config.EnableQuerySupport();
            config.MapHttpAttributeRoutes();

            //config.Routes.MapHttpRoute(
            //    name: "DefaultApi",
            //    routeTemplate: "api/{controller}/{id}",
            //    defaults: new { id = RouteParameter.Optional }
            //);

            config.Routes.MapHttpRoute(
                name: "ActionApi",
                routeTemplate: "odata/{controller}/{action}/{id}",
                defaults: new { id = RouteParameter.Optional }
            );
        }

        
    }
}
