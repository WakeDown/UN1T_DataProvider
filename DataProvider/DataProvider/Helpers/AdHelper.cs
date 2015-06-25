using System;
using System.Collections.Generic;
using System.DirectoryServices;
using System.DirectoryServices.AccountManagement;
using System.Linq;
using System.Net;
using System.Security.Principal;
using System.Web;
using System.Web.SessionState;
using DataProvider.Models.Stuff;
using DataProvider.Objects;

namespace DataProvider.Helpers
{
    public class AdHelper
    {
        private const string DomainPath = "LDAP://DC=UN1T,DC=GROUP";
        private static NetworkCredential nc = GetAdUserCredentials();

        public static NetworkCredential GetAdUserCredentials()
        {
            string accUserName = "UN1T\rehov";
            string accUserPass = "R3xQwi!!";

            string domain = "UN1T";//accUserName.Substring(0, accUserName.IndexOf("\\"));
            string name = "rehov";//accUserName.Substring(accUserName.IndexOf("\\") + 1);

            NetworkCredential nc = new NetworkCredential(name, accUserPass, domain);

            return nc;
        }

        private static string GetLoginFromEmail(string email)
        {
            return !string.IsNullOrEmpty(email) ? email.Substring(0, email.IndexOf("@", StringComparison.Ordinal)) : String.Empty;
        }

        public static void SaveUser(ref Employee emp)
        {
            if (!emp.HasAdAccount) return;

            string username = GetLoginFromEmail(emp.Email);

            if (String.IsNullOrEmpty(username.Trim())) return;
            string mail = emp.Email;
            string fullName = emp.FullName;
            string surname = emp.Surname;
            string name = emp.Name;
            string position = emp.Position != null ? emp.Position.Name : String.Empty;
            string workNum = emp.WorkNum;
            string mobilNum = emp.MobilNum;
            string city = emp.City != null ? emp.City.Name : String.Empty;
            string org = emp.Organization != null ? emp.Organization.Name : String.Empty;
            string dep = emp.Department != null ? emp.Department.Name : String.Empty;
            var photo = emp.Photo != null && emp.Photo.Length > 0 ? emp.Photo : null;
            string managerUsername = String.Empty;
            if (emp.Department != null && Department.CheckUserIsChief(emp.Department.Id, emp.Id))
            {
                

                var currDep = new Department(emp.Department.Id);
                if (currDep.ParentDepartment != null && currDep.ParentDepartment.Id > 0)
                {
                    var parentDep = new Department(currDep.ParentDepartment.Id);
                    var overManager = new Employee(parentDep.Chief.Id);
                    managerUsername = GetLoginFromEmail(overManager.Email);
                }
            }
            else
            {
                managerUsername = emp.Manager != null ? GetLoginFromEmail(emp.Manager.Email) : String.Empty;
            }
            string mnagerName = String.Empty;
            bool userIsExist = false;

            DirectoryEntry directoryEntry = new DirectoryEntry(DomainPath);

            using (directoryEntry)
            {
                //Если пользователь существует
                DirectorySearcher search = new DirectorySearcher(directoryEntry);
                search.Filter = String.Format("(&(objectClass=user)(sAMAccountName={0}))", username);
                SearchResult resultUser = search.FindOne();
                userIsExist = resultUser != null && resultUser.Properties.Contains("sAMAccountName");
            }

            if (!String.IsNullOrEmpty(managerUsername.Trim()))
            {
                using (directoryEntry)
                {
                    DirectorySearcher search = new DirectorySearcher(directoryEntry);
                    search.Filter = String.Format("(&(objectClass=user)(sAMAccountName={0}))", managerUsername);
                    search.PropertiesToLoad.Add("DistinguishedName");
                    SearchResult resultManager = search.FindOne();
                    if (resultManager != null) mnagerName = (string)resultManager.Properties["DistinguishedName"][0];
                }
            }

            if (!userIsExist)
            {
                //Создаем аккаунт в AD
                using (var pc = new PrincipalContext(ContextType.Domain, "UN1T", "OU=Users,OU=UNIT,DC=UN1T,DC=GROUP"))
                {
                    using (var up = new UserPrincipal(pc))
                    {
                        up.SamAccountName = username;
                        up.UserPrincipalName = username;
                        up.SetPassword("z-123456");
                        up.Enabled = true;
                        up.ExpirePasswordNow();
                        using (WindowsImpersonationContextFacade impersonationContext
                            = new WindowsImpersonationContextFacade(
                                nc))
                        {
                            try
                            {
                                up.Save();
                            }
                            catch (PrincipalOperationException ex)
                            {
                                
                            }
                        }


                    }
                }

                //Создаем аккаунт в Exchange

                //Создаем аккаунт в Lync
            }

            //Еще один путь для изменения параметров
            //if (up.GetUnderlyingObjectType() == typeof(DirectoryEntry))
            //{
            //    DirectoryEntry entry = (DirectoryEntry)up.GetUnderlyingObject();
            //        entry.Properties["streetAddress"].Value = address;

            //        entry.CommitChanges();

            //}

            directoryEntry = new DirectoryEntry(DomainPath);
            using (directoryEntry)
            {

                //DirectoryEntry user = directoryEntry.Children.Add("CN=" + username, "user");
                DirectorySearcher search = new DirectorySearcher(directoryEntry);
                search.Filter = String.Format("(&(objectClass=user)(sAMAccountName={0}))", username);
                search.PropertiesToLoad.Add("objectsid");
                search.PropertiesToLoad.Add("samaccountname");
                search.PropertiesToLoad.Add("userPrincipalName");
                search.PropertiesToLoad.Add("mail");
                search.PropertiesToLoad.Add("usergroup");
                search.PropertiesToLoad.Add("displayname");
                search.PropertiesToLoad.Add("givenName");
                search.PropertiesToLoad.Add("sn");
                search.PropertiesToLoad.Add("title");
                search.PropertiesToLoad.Add("telephonenumber");
                search.PropertiesToLoad.Add("homephone");
                search.PropertiesToLoad.Add("mobile");
                search.PropertiesToLoad.Add("manager");
                search.PropertiesToLoad.Add("l");
                search.PropertiesToLoad.Add("company");
                search.PropertiesToLoad.Add("department");
                //search.PropertiesToLoad.Add("userAccountControl");
                SearchResult resultUser = search.FindOne();

                if (resultUser == null) return;

                DirectoryEntry user = resultUser.GetDirectoryEntry();
                //user.Properties["sAMAccountName"].Value =username;
                //user.Properties["userPrincipalName"].Value =username;
                SetProp(ref user, ref resultUser, "mail", mail);
                SetProp(ref user, ref resultUser, "displayname", fullName);
                SetProp(ref user, ref resultUser, "givenName", surname);
                SetProp(ref user, ref resultUser, "sn", name);
                SetProp(ref user, ref resultUser, "title", position);
                SetProp(ref user, ref resultUser, "telephonenumber", workNum);
                SetProp(ref user, ref resultUser, "mobile", mobilNum);
                SetProp(ref user, ref resultUser, "l", city);
                SetProp(ref user, ref resultUser, "company", org);
                SetProp(ref user, ref resultUser, "department", dep);
                SetProp(ref user, ref resultUser, "manager", mnagerName);
                user.Properties["jpegPhoto"].Clear();
                SetProp(ref user, ref resultUser, "jpegPhoto", photo);
                using (WindowsImpersonationContextFacade impersonationContext
                    = new WindowsImpersonationContextFacade(
                        nc))
                {
                    user.CommitChanges();
                }
                SecurityIdentifier sid = new SecurityIdentifier((byte[])resultUser.Properties["objectsid"][0],
                    0);

                if (String.IsNullOrEmpty(emp.AdSid))
                {
                    string s = "";
                }

                if (String.IsNullOrEmpty(emp.AdSid) || emp.AdSid != sid.Value)
                {
                    var e = new Employee(emp.Id);
                    if (String.IsNullOrEmpty(e.AdSid) || e.AdSid != sid.Value)
                    {
                        e.AdSid = sid.Value;
                        e.Save();
                    }
                }
                emp.AdSid = sid.Value;
            }
        }

        public static void SetProp(ref DirectoryEntry user, ref SearchResult result, string name, object value)
        {
            if (value == null || String.IsNullOrEmpty(value.ToString()) || String.IsNullOrEmpty(name)) return;
            if (result.Properties.Contains(name))
            {
                user.Properties[name].Value = value;
            }
            else
            {
                user.Properties[name].Add(value);
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

                DirectoryEntry directoryEntry = new DirectoryEntry(DomainPath);
                using (directoryEntry)
                {
                    DirectorySearcher search = new DirectorySearcher(directoryEntry);
                    search.Filter = String.Format("(&(objectClass=user)(sAMAccountName={0}))", login);
                    SearchResult result = search.FindOne();
                    flag = result != null && result.Properties.Contains("sAMAccountName");
                }
                i++;
            } while (flag);

            return login;
        }


    }
}