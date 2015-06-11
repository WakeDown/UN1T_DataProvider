using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace DataProvider.Models.Stuff
{
    public class Employee
    {
        public int Id { get; set; }
        public string AdSid { get; set; }
        public Employee Manager { get; set; }
        [StringLength(50), Required]
        public string Surname { get; set; }
        [StringLength(50), Required]
        public string Name { get; set; }
        [StringLength(50)]
        public string Patronymic { get; set; }
        public string FullName { get; set; }
        public string DisplayName { get; set; }
        public Position Position { get; set; }
        public Organization Organization { get; set; }
        [StringLength(150), Required]
        public string Email { get; set; }
        [StringLength(50), Required]
        public string WorkNum { get; set; }
        [StringLength(50), Required]
        public string MobilNum { get; set; }
        public EmpState EmpState { get; set; }
        public Department Department { get; set; }
        public City City { get; set; }
        public byte[] Photo { get; set; }
        [DataType(DataType.Date), Required]
        public DateTime? DateCame { get; set; }

        public Employee() { }

        public Employee(int id)
        {
            Id = id;
            AdSid = "12213ohjboi5345oijbnio";
            Manager = new Employee() { DisplayName = "Медведевских А.А." };
            Surname = "Рехов";
            Name = "Антон";
            Patronymic = "Игоревич";
            FullName = "Рехов Антон Игоревич";
            DisplayName = "Рехов А.И.";
            Position = new Position() { Id = 1, Name = "Pos1" };
            Organization = new Organization() { Id = 1, Name = "Org1" };
            Email = "anton.rehov@unitgroup.ru";
            WorkNum = "111";
            MobilNum = "+79536001000";
            Department = new Department() { Id = 1, Name = "Dep1" };
            City = new City() { Id = 1, Name = "City1" };
            DateCame = DateTime.Now;
        }

        internal void Save()
        {
            Id = 1;
        }
    }
}