using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using WcfDataProvider.Models;
using WcfDataProvider.Models.Stuff;

namespace WcfDataProvider.DbServices.Stuff
{
    // ПРИМЕЧАНИЕ. Команду "Переименовать" в меню "Рефакторинг" можно использовать для одновременного изменения имени класса "Service1" в коде, SVC-файле и файле конфигурации.
    // ПРИМЕЧАНИЕ. Чтобы запустить клиент проверки WCF для тестирования службы, выберите элементы Service1.svc или Service1.svc.cs в обозревателе решений и начните отладку.
    public class EmployeeService : IDbService
    {
        public ICollection<DbObject> GetList()
        {
            return new Collection<DbObject>() { new Employee(1), new Employee(2) };
        }

        public DbObject Get(int id)
        {
            return new Employee(id);
        }

        public string Save(DbObject emp)
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
