using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace WcfDataProvider.Models.Stuff
{
    [DataContract]
    public class Employee : DbObject
    {
        [DataMember]
        public int Id { get; set; }
        [DataMember]
        public string AdSid { get; set; }
        [DataMember]
        public Employee Manager { get; set; }
        //[StringLength(50), Required]
        [DataMember]
        public string Surname { get; set; }
        //[StringLength(50), Required]
        [DataMember]
        public string Name { get; set; }
        //[StringLength(50)]
        [DataMember]
        public string Patronymic { get; set; }
        [DataMember]
        public string FullName { get; set; }
        [DataMember]
        public string DisplayName { get; set; }
        [DataMember]
        public Position Position { get; set; }
        [DataMember]
        public Organization Organization { get; set; }
        //[StringLength(150), Required]
        [DataMember]
        public string Email { get; set; }
        //[StringLength(50), Required]
        [DataMember]
        public string WorkNum { get; set; }
        //[StringLength(50), Required]
        [DataMember]
        public string MobilNum { get; set; }
        [DataMember]
        public EmpState EmpState { get; set; }
        [DataMember]
        public Department Department { get; set; }
        [DataMember]
        public City City { get; set; }
        [DataMember]
        public byte[] Photo { get; set; }
        //[DataType(DataType.Date), Required]
        [DataMember]
        public DateTime? DateCame { get; set; }

        [DataMember]
        public AdGroup[] AdGroups { get; set; }

        public Employee() { }

        public Employee(int id)
        {
            Id = id;
            AdSid = "12213ohjboi5345oijbnio";
            Manager=new Employee(){DisplayName = "Медведевских А.А."};
            Surname = "Рехов";
            Name = "Антон";
            Patronymic = "Игоревич";
            FullName = "Рехов Антон Игоревич";
            DisplayName = "Рехов А.И.";
            Position = new Position(){Id=1, Name = "Pos1"};
            Organization = new Organization() {Id=1,Name = "Org1"};
            Email = "anton.rehov@unitgroup.ru";
            WorkNum = "111";
            MobilNum = "+79536001000";
            Department = new Department(){Id=1,Name="Dep1"};
            City=new City(){Id=1, Name = "City1"};
            DateCame = DateTime.Now;
        }

        internal void Save()
        {
            Id = 1;
        }
    }
}