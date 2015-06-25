using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Runtime.Remoting.Channels;
using System.Web.Http;
using System.Web.Http.OData;
using DataProvider.Helpers;
using DataProvider.Models.Stuff;
using DataProvider.Objects;

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

        public Employee Get(string adSid)
        {
            var dep = new Employee(adSid);
            return dep;
        }

        [AllowAnonymous]
        public HttpResponseMessage GetPhoto(string adSid)
        {
            HttpResponseMessage httpResponseMessage = new HttpResponseMessage();

            var emp = new Employee(adSid, true);
            if (emp.Photo == null || (emp.Photo != null && emp.Photo.Length == 0))
            {
                if (emp.Male)
                {
                    emp.Photo = File.ReadAllBytes(System.Web.Hosting.HostingEnvironment.MapPath("~/Content/images/no_photo_male.jpg"));
                }
                else { emp.Photo = File.ReadAllBytes(System.Web.Hosting.HostingEnvironment.MapPath("~/Content/images/no_photo_female.png")); }
            }

            httpResponseMessage.Content = new ByteArrayContent(emp.Photo);

            httpResponseMessage.Content.Headers.ContentType = new MediaTypeHeaderValue("image/gif");
            httpResponseMessage.StatusCode = HttpStatusCode.OK;

            return httpResponseMessage;
        }

        [AllowAnonymous]
        public HttpResponseMessage GetPhoto(int id)
        {
            HttpResponseMessage httpResponseMessage = new HttpResponseMessage();

            var emp = new Employee(id, true);
            if (emp.Photo == null || (emp.Photo != null && emp.Photo.Length == 0))
            {
                if (emp.Male)
                {
                    emp.Photo = File.ReadAllBytes(System.Web.Hosting.HostingEnvironment.MapPath("~/Content/images/no_photo_male.jpg"));
                }
                else { emp.Photo = File.ReadAllBytes(System.Web.Hosting.HostingEnvironment.MapPath("~/Content/images/no_photo_female.png")); }
            }

            httpResponseMessage.Content = new ByteArrayContent(emp.Photo);

            httpResponseMessage.Content.Headers.ContentType = new MediaTypeHeaderValue("image/gif");
            httpResponseMessage.StatusCode = HttpStatusCode.OK;

            return httpResponseMessage;
        }

        [AuthorizeAd(Groups =new[]{AdGroup.PersonalManager} )]
        public HttpResponseMessage Save(Employee emp)
        {
            //TODO: Проверить может ли пользователь создавать новых сотрудников

            HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.Created);

            try
            {
                emp.Save();

                if (emp.HasAdAccount)
                {
                    Employee e = new Employee(emp.Id);
                    AdHelper.SaveUser(ref e);
                }

                response.Content = new StringContent(String.Format("{{\"id\":{0}}}", emp.Id));
            }
            catch (Exception ex)
            {
                response = new HttpResponseMessage(HttpStatusCode.OK);
                response.Content = new StringContent(MessageHelper.ConfigureExceptionMessage(ex));
            }
            return response;
        }
        [AuthorizeAd(Groups = new[] { AdGroup.PersonalManager })]
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
                response.Content = new StringContent(MessageHelper.ConfigureExceptionMessage(ex));

            }
            return response;
        }

        public IEnumerable<Employee> GetTodayBirthdayList()
        {
            return Employee.GetDayBirthdayList(DateTime.Now);
        }

        public IEnumerable<Employee> GetNextMonthBirthdayList()
        {
            return Employee.GetMonthBirthdayList(DateTime.Now.AddMonths(1).Month);
        }

        public IEnumerable<string> GetFullRecipientList()
        {
            return Employee.GetFullRecipientList();
        }
    }
}
