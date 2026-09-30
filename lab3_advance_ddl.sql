--part a
create database advanced_lab
    with owner = postgres
    template=template0
    encoding = 'UTF8',
    with connection limit = 50;

create table employees(
    emp_id serial primary key,
    first_name text,
    last_name text,
    department text,
    salary int,
    hire_date date,
    status text default "Active"
);

create table departments(
    dept_id serial primary key,
    dept_name text,
    budget int,
    manager_id int
);

create table projects(
    project_id serial primary key,
    project_name text,
    dept_id int,
    start_date date,
    end_date date,
    budget int
);
--part b
insert into employees (emp_id, first_name,last_name, department) values (1234,'Tom','Smith','IT');
insert into employees (first_name, last_name, salary,status) values ('Alice','Smith',default,default);
insert into departments(dept_id,dept_name) values (1,'IT'),(2,'Sales'),(3,'SMM');
--part c
update employees set salary=salary*1.10;
update employees set status = 'Senior' where salary>60000 and hire_date<'2020-01-01';
update employees set department=case when salary>80000 then 'Managment' when salary between 50000 and 80000 then 'Senior' else 'Junior' end;
update  employees set department = default where status = 'Inactive';
update departments d set budget =(
    select avg(e.salary)*1.20
    from employees e
    where e.department =d.dept_id
    );
update employees set salary = salary*1.15, status='Promoted' where department='Sales';
--part d
delete from employees where status='Terminated';
delete from employees where salary<40000 and hire_date >'2023-01-01' and department is null;
delete from departments where dept_id not in (
    select distinct department
    from employees
    where department is not null
    );
delete from projects where end_date <'2023-01-01' returning  *;
--part e
insert into employees(first_name, last_name, department, salary) values ('James','Will',null,null);
update employees set department='Unassigned' where department is null;
delete from employees where salary is null or department is null;
--part f
insert into employees(first_name, last_name, department, salary) values ('Emma','Stone','IT',55000) returning emp_id,first_name ||' '|| last_name as full_name;
with old_data as(
    select emp_id,salary
    from employees
    where department='IT'
)
update employees e set salary=salary+5000 from old_data o where e.emp_id =o.emp_id returning e.emp_id, o.salary as old_salary,e.salary as new_salary;
delete from employees where hire_date <'2020-01-01' returning *;
--part g
insert into employees(first_name, last_name, department, salary) select 'Tom','Smith','IT',60000 where not exists(
    select 1
    from employees
    where   first_name='Tom'
    and last_name='Smith'
);

update employees e set salary=salary*case
    when d.budget > 100000 then 1.10 else 1.05
end
from departments d where e.department = d.dept_id;
insert into employees(first_name,last_name,salary,department)
values ('John', 'Smith', 50000, 'IT'),
    ('Anna', 'Brown', 55000, 'Sales'),
    ('Mike', 'Wilson', 60000, 'HR'),
    ('Kate', 'Taylor', 65000, 'IT'),
    ('David', 'Lee', 70000, 'Sales');
update employees set salary=salary*1.10 where first_name in ('John', 'Anna', 'Mike', 'Kate', 'David') and last_name in ('Smith', 'Brown', 'Wilson', 'Taylor', 'Lee');

create table employee_archive as
    select * from employees where false;

delete from employees where status='Inactive';

update projects p
set end_date=end_date+interval '30 days'
where p.budget >50000 and (
    select count(*)
    from employees e
    where e.department = p.depatment
    )>3;
