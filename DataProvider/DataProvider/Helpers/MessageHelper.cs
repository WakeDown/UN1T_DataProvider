﻿using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net.Mail;
using System.Web;
using DataProvider.Models.SpeCalc;

namespace DataProvider.Helpers
{
    public class MessageHelper
    {
        private static MailAddress defaultMailFrom = new MailAddress("UN1T@un1t.group");
        public static string ConfigureExceptionMessage(Exception ex)
        {
            var st = new StackTrace(ex, true);
            var frame = st.GetFrame(0);
            var line = frame.GetFileLineNumber();

            return String.Format("{{\"errorMessage\":\"{0} {2}: {1}\"}}", ex.Source, ex.Message.Replace("\"", ""), line);
        }

        public static void SendMailSmtp(string subject, string body, bool isBodyHtml, string mailTo,
            string mailFrom = null, bool isTest = false)
        {
            SendMailSmtp(subject, body, isBodyHtml, new [] { mailTo }, mailFrom, isTest);
        }

        public static void SendMailSmtp(string subject, string body, bool isBodyHtml, IEnumerable<string> mailTo,
            string mailFrom = null, bool isTest = false)
        {
            var recipients = new List<MailAddress>();
            foreach (var email in mailTo)
            {
                if (String.IsNullOrEmpty(email)) continue;
                recipients.Add(new MailAddress(email));
            }
            if (String.IsNullOrEmpty(mailFrom)) mailFrom = defaultMailFrom.Address;
            SendMailSmtp(subject, body, isBodyHtml, recipients.ToArray(), new MailAddress(mailFrom), isTest);
        }

        public static void SendMailSmtp(string subject, string body, bool isBodyHtml, MailAddress[] mailTo, MailAddress mailFrom = null, bool isTest = false)
        {

            if (!mailTo.Any()) throw new Exception("Не указаны получатели письма!");

            if (mailFrom == null || String.IsNullOrEmpty(mailFrom.Address)) mailFrom = defaultMailFrom;

            MailMessage mail = new MailMessage();

            SmtpClient client = new SmtpClient();
            client.Port = 25;
            client.DeliveryMethod = SmtpDeliveryMethod.Network;

            mail.From = mailFrom;

            client.EnableSsl = false;

            if (!isTest)
            {
                foreach (MailAddress mailAddress in mailTo)
                {
                    if (String.IsNullOrEmpty(mailAddress.Address))continue;
                    mail.To.Add(mailAddress);
                }
            }
            else
            {
                foreach (var email in Settings.Emails4Test)
                {
                    if (String.IsNullOrEmpty(email)) continue;
                    mail.To.Add(email);
                }
                
                body += "\r\n";
                foreach (var mailAddress in mailTo)
                {
                    body += "\r\n" + mailAddress.Address;
                }
            }
            //mail.To.Clear();
            //mail.To.Add(new MailAddress("anton.rehov@unitgroup.ru"));
            //mail.To.Add(new MailAddress("alexander.medvedevskikh@unitgroup.ru"));

            mail.Subject = subject;
            mail.Body = body;
            mail.IsBodyHtml = isBodyHtml;

            client.Host = "ums-1";

            try
            {
                client.Send(mail);
            }
            catch (Exception ex)
            {
                
                throw new Exception(String.Format("Сообщение не было отправлено. Текст ошибки - {0}", ex.Message));
            }
            
        }
    }
}