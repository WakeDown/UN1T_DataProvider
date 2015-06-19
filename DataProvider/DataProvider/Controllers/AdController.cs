using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using DataProvider.Helpers;

namespace DataProvider.Controllers
{
    public class AdController : ApiController
    {
        [HttpGet]
        public string GetEmailAddressByName(string surname, string name)
        {
            return String.Format("{0}@unitgroup.ru", GetLoginByName(surname, name));
        }
        [HttpGet]
        public string GetLoginByName(string surname, string name)
        {
            return AdHelper.GenerateLoginByName(surname, name);
            //HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.Created);

            //try
            //{
            //    response.Content = new StringContent(AdHelper.CreateLoginByName(surname, name));
            //}
            //catch (Exception ex)
            //{
            //    response = new HttpResponseMessage(HttpStatusCode.OK);
            //    response.Content = new StringContent(String.Format("{{\"errorMessage\":\"{0}\"}}", ex.Message));

            //}
            //return response;
        }
    }
}
