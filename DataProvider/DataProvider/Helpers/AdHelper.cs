using System;
using System.Collections.Generic;
using System.DirectoryServices;
using System.Linq;
using System.Web;
using DataProvider.Models.Stuff;
using DataProvider.Objects;

namespace DataProvider.Helpers
{
    public class AdHelper
    {
        private const string DomainPath = "LDAP://DC=UN1T,DC=GROUP";
        private static DirectoryEntry directoryEntry = new DirectoryEntry(DomainPath);

        public static void CreateUser(Employee emp)
        {
            string username = "johndoe";

            using (directoryEntry)
            {
                DirectoryEntry user = directoryEntry.Children.Add("CN=" + username, "user");

                user.Properties["sAMAccountName"].Add(username);

                directoryEntry.CommitChanges();
            }
        }

        public static string GenerateLoginByName(string surname, string name)
        {
            string login = String.Empty;
            int maxLoginLength = 19;//-1 - потомучто будет точка
            var trans = new Transliteration();
            string surnameTranslit = trans.GetTranslit(surname);
            string nameTranslit = trans.GetTranslit(name);
            //Если длина транслита превышает максимальное значение
            if (surnameTranslit.Length > maxLoginLength)
            {

                surnameTranslit = surnameTranslit.Substring(0, maxLoginLength);
                nameTranslit = String.Empty;
            }
            else if (surnameTranslit.Length + nameTranslit.Length > maxLoginLength)
            {
                nameTranslit = nameTranslit.Substring(0, maxLoginLength - surnameTranslit.Length);
            }

            bool flag = false;
            int i = 0;
            int j = 1;
            string nameAccount = nameTranslit;
            string surnameAccount = surnameTranslit;
            do
            {
            if (i >= 1 && i < nameTranslit.Length)
            {
                nameAccount = nameTranslit.Substring(0, i);
            }
            else if (i >= 1 && i >= nameTranslit.Length)
            {
                login = "ERROR";
                break;
                //nameAccount = String.Format("{1}{0}", nameTranslit, j++);
            }

                login = String.Format("{0}.{1}", nameAccount, surnameAccount).ToLower();

                using (directoryEntry)
                {
                    DirectorySearcher search = new DirectorySearcher(directoryEntry);
                    search.Filter = String.Format("(&(objectClass=user)(sAMAccountName={0}))", login);
                    SearchResult result = search.FindOne();
                    flag = result!= null && result.Properties.Contains("sAMAccountName");
                }
                i++;
            } while (flag);

            return login;
        }

        
    }
}