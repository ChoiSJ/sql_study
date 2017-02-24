create table test_table (
	no number(5) primary key,
	id varchar(10) not null,
	password varchar(100) not null,
	name varchar(10) not null,
	phone varchar(15),
	email varchar(50),
	post varchar(15),
	address varchar(100),
	join_date date default sysdate,
	
	unique (id)
);

insert into test_table (no, id, password, name, phone, email, post, address)
values (1, 'testid', 'testpwd', 'table', '010-1111-1111', 'test@gmail.com', '11111', '경기도');

delete from test_table;

commit;

create index first_name_index
on employees (first_name);

create or replace view employees_view
as
select A.employee_id as employee_id,
	A.first_name || ' ' || A.last_name as employee_name,
	A.phone_number as phone_number,
	A.department_id as department_id,
	B.department_name as department_name,
	A.salary as salary,
	A.commission_pct as commission_pct,
	A.salary * 12 as annual_salary,
	A.job_id as job_id,
	A.hire_date as hire_date
from employees A, departments B
where A.department_id = B.department_id;

select A.department_id, B.department_name, A.first_name
from employees A, departments B
where A.department_id = B.department_id
and A.employee_id = B.manager_id;

select department_id, count(department_id)
from employees
group by department_id
having count(department_id) >= 5;

create user test
identified by zxcv1234;

CREATE OR REPLACE PROCEDURE test_pro (dep_no IN NUMBER, com_pct IN NUMBER)
IS
BEGIN
   UPDATE employees
      SET salary = salary + salary * com_pct
    WHERE department_id = dep_no;
END test_pro;
/

CREATE OR REPLACE FUNCTION test_fun (dep_id IN NUMBER)
   RETURN NUMBER
IS
   dep_no   NUMBER;
BEGIN
     SELECT COUNT (department_id)
       INTO dep_no
       FROM employees
      WHERE department_id = dep_id
   GROUP BY department_id;

   RETURN dep_no;
END test_fun;