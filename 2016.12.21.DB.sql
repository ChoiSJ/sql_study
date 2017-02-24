select *
from user_constraints;

create table emp30
as select employee_id, first_name, job_id, hire_date, salary, department_id
from employees
where department_id = 30;

alter table emp30
add (comm number(2, 2));

-- delete from emp30;

truncate table emp30;

create sequence my_seq;

select my_seq.nextval
from dual;

insert into tb_book(no, title, author, publisher, price, pubdate)
values (my_seq.nextval, '이것이 자바다', '신용권', '한빛미디어', 35000, sysdate);

select my_seq.currval
from dual;

create sequence my_seq2
				increment by 100
				start with 1000;
				
select my_seq2.nextval
from dual;

drop sequence my_seq;
drop sequence my_seq2;

create sequence school_seq
				nocache;
				
create or replace view employees_annual_salary_view
as 
select A.employee_id, A.first_name || ', ' || A.last_name as full_name, 
	   A.job_id, A.salary, A.salary*12 + A.salary*12*nvl(A.commission_pct, 0) as annual_salary,
	   A.department_id,
	   B.department_name
from employees A, departments B
where A.department_id = B.department_id;

-- 교수정보와 그 교수가 개설한 과목정보를 가지는 뷰
create or replace view subject_detail_view 
as
select A.no			as subject_no,
	   A.name		as subject_name,
	   A.type		as subject_type,
	   A.limit		as subject_limit,
	   B.no			as professor_no,
	   B.name		as professor_name
from tb_subject A, tb_professor B
where A.prof_no = B.no;

select *
from subject_detail_view
where subject_type = '교양';

-- 수강신청한 학생정보와 그 학생이 수강한 과목정보를 가지는 뷰
create or replace view course_detail_view
as
select B.no as stud_no,
	   B.name as stud_name,
	   B.major as stud_major,
	   B.grade as stud_grade,
	   C.*
from tb_course A, tb_student B, subject_detail_view C
where A.stud_no = B.no
and A.subj_no = C.subject_no;

select *
from course_detail_view
where stud_no = 10;

select A.first_name, A.salary, A.salary - B.avg_salary
from employees A, (select round(avg(salary)) as avg_salary
				   from employees) B;
				   
-- 급여를 많이 받는 사람 3명 조회하기
select rownum as rank, first_name, salary
from (select first_name, salary
	  from employees
	  order by salary desc)
where rownum <= 10;

select rank, first_name, salary
from (select row_number() over (order by salary desc) as rank,
	  first_name, salary
	  from employees)
where rank >= 6 and rank <=10;

select row_number() over (order by salary desc) as rank,
	   first_name, salary
from employees;

select rank() over (order by salary desc) as rank,
	   first_name, salary
from employees;

select A.first_name, A.salary, A.salary - B.avg_salary
from employees A, (select round(avg(salary)) as avg_salary
				   from employees) B;
				   