-- tx1 begin
update tb_book set price = 50000 where no = 1;
insert into tb_book values (2, '자바의 정석', '남궁성', '도우출판', 30000, sysdate);

select * from tb_book;
commit;
-- tx1 그룹 내에서 수행했던 DML작업이 db에 영구적으로 반영된다.
-- tx1 end

-- tx2 begin
delete from tb_book where no = 1;
insert into tb_book values (30, '도가니', '공지영', '창비', 18000, sysdate);

rollback;
-- tx2 그룹 내의 DML 작업이 전부 취소된다.
-- tx2 end

-- tx3 begin

create table tb_account (
	no varchar(20) primary key,
	owner varchar(100),
	balance number(8)
);

insert into tb_account values ('11-11-11', '홍길동', 2000000);
insert into tb_account values ('22-22-22', '김유신', 10);
insert into tb_account values ('33-33-33', '이순신', 5000);
commit;

-- 사원번호와 현재 업무를 조회하기
select employee_id, job_id from employees;

-- 사원번호와 이전 업무 조회하기
select employee_id, job_id from job_history;

-- 모든 사원의 현재/과거 업무를 조회하기
select employee_id, job_id
from employees 
where employee_id >= 200
union all
select employee_id, job_id 
from job_history 
where employee_id >= 200
order by employee_id asc;

-- 현재 담당하는 업무가 입사이후 이전에 담당했던 적이 있는 업무에 종사하는 사원의 아이디와 업무를 조회하기
select employee_id, job_id
from employees
intersect
select employee_id, job_id
from job_history;

-- 업무를 변경한 적이 없는 사원아이디와 업무 조회하기
select A.employee_id, B.job_id, B.salary
from (select employee_id
	  from employees
	  minus
	  select employee_id
	  from job_history) A, employees B
where A.employee_id = B.employee_id;

select A.no, (select name from tb_student where no = A.no) name,
	(select count(*) from tb_course where stud_no = A.no) cnt
from (select no
	from tb_student
	intersect
	select stud_no
	from tb_course) A;

-- 관리자로 지정된 사원들의 아이디, 이름 및 관리하는 사원수를 조회하기
select A.manager_id,
	(select first_name from employees where employee_id = A.manager_id) name,
	(select count(*) from employees where manager_id = A.manager_id) cnt
from (select manager_id
	from employees
	intersect
	select employee_id
	from employees) A;
	
select A.manager_id, B.first_name,
	(select count(*) from employees where manager_id = A.manager_id) cnt 
from (select distinct manager_id
	from employees
	where manager_id is not null) A, employees B
where A.manager_id = B.employee_id 
order by A.manager_id;

-- 관리자로 지정된 사원 중에서 관리하는 사원이 5명 이하인 매니저의 사원아이디, 이름 관리하는 사원 수를 조회하기
select A.manager_id, B.first_name, cnt
from (select manager_id, count(*) cnt
	from employees
	where manager_id is not null
	group by manager_id
	having count(*) < 5) A, employees B
where A.manager_id = B.employee_id

select employee_id, first_name, salary,
	case when salary <= 5000 then (select trunc(avg(salary)/2) from employees)
		when salary <= 10000 then (select trunc(avg(salary)/4) from employees)
	else 0
	end bonus
from employees;

-- 입사일이 매월 16일 이전인 사원을 조회하기
select first_name, hire_date
from employees
where to_char(hire_date, 'dd') <= 16;

-- 모든 사원의 이름, 급여를 조회하기(급여는 천단위로 표시하기)
select first_name, trunc(salary/1000) as salary
from employees;

-- 평균급여가 가장 높은 부서의 부서 번호 및 해당 부서의 최저 급여를 조회하기
select department_id, min(salary)
from employees
group by department_id
having avg(salary) = (select max(avg(salary))
					from employees
					group by department_id);
					
with 
	emp_salary as (
		select department_id, avg(salary) avg_salary,
							max(salary) max_salary,
							min(salary) min_salary
		from employees
		group by department_id
	)
select *
from emp_salary
where avg_salary = (select max(avg_salary)
					from emp_salary);

-- 사원이 3명 미만인 부서의 부서번호, 부서명, 사원수를 표시하기
select A.department_id, B.department_name, A.cnt
from (select department_id, count(*) cnt
	from employees
	group by department_id
	having count(*) < 3) A, departments B
where A.department_id = B.department_id
order by department_id asc;

-- 사원수가 가장 많은 부서의 부서번호, 부서명, 사원수를 표시하기
select A.department_id, B.department_name, A.cnt
from (select department_id, count(*) cnt
	from employees
	group by department_id) A, departments B
where A.department_id = B.department_id
and A.department_id = (select department_id
					from employees
					group by department_id
					having count(*) = (select max(count(*))
									from employees
									group by department_id));

-- 급여가 15000 달러를 초과하는 관리자가 관리하는 모든 사원이름, 관리자의 이름, 관리자의 급여, 급여 등급을 조회하기
select A.first_name, B.first_name, A.salary, C.gra
from (select employee_id, first_name, salary from employees where salary > 15000) A,
	employees B, job_grades C
where A.employee_id = B.manager_id
and A.salary >= C.lowest_sal and A.salary <= C.highest_sal;

select emp.first_name 사원명, man.first_name 관리자명, man.salary 관리자급여,
	grade.gra 급여등급
from employees emp, employees man, job_grades grade
where emp.manager_id = man.employee_id
and man.salary >= grade.lowest_sal and man.salary <= grade.highest_sal
and emp.manager_id in (select employee_id
					from employees
					where salary > 15000);

-- 모든 사원의 사원번호, 이름, 급여, 소속부서 번호, 소속 부서의 평균 급여를 조회하기
select B.employee_id, B.first_name, B.salary, A.department_id, A.AVG
from (select department_id, trunc(avg(salary)) AVG
	from employees
	group by department_id) A, employees B
where A.department_id = B.department_id;

-- 입사년도에 상관 없이 1월에 입사한 사원의 이름, 입사한 날을 조회하기(입사일은 2001.01.11 형식으로 표시)
select first_name, to_char(hire_date, 'yyyy.mm.dd')
from employees 
where to_char(hire_date, 'mm') = 1;

-- 사원들 중에서 가장 많은 급여를 받는 사원 3명의 이름과 급여를 조회하기
select rownum as rank, first_name, salary
from employees
where rownum <= 3
order by rank asc;

-- california 주에 근무하는 사원의 사원번호와 이름을 표시하기
select employee_id, first_name
from employees
where department_id = (select department_id
					from departments
					where location_id = (select location_id
										from locations
										where state_province = 'California'));
										
-- 2005년 상반기와 2006년 상반기에 신규 사원이 추가된 업무를 조회하기
select A.job_id
from (select job_id
	from employees
	where to_char(hire_date, 'yyyy.mm.dd') >= to_char('2005.01.01')
	and to_char(hire_date, 'yyyy.mm.dd') < to_char('2005.07.01')
	union
	select job_id
	from employees
	where to_char(hire_date, 'yyyy.mm.dd') >= to_char('2006.01.01')
	and to_char(hire_date, 'yyyy.mm.dd') < to_char('2006.07.01')) A;

-- 모든 사원의 이름과 근무년수, 근무개월수를 조회하기
select first_name, months_between(sysdate, hire_date)/12 as YEAR, 
	months_between(sysdate, hire_date) as MONTH
from employees;

-- 근무 도시별 사원수를 조회하고, 도시명, 사원수명, 그 도시에 위치한 부서갯수를 표시하기
select C.city, A.EMPLOYEES, B.DEPARTMENTS
from (select location_id, count(*) EMPLOYEES 
	from employees A, departments B 
	where A.department_id = B.department_id 
	group by location_id) A,
	(select location_id, count(*) DEPARTMENTS
	from departments 
	group by location_id) B, locations C
where A.location_id = C.location_id and B.location_id = C.location_id;
	
-- 지역별(대륙별)로 사원수를 조회해서 표시하기(sum, decode) 활용
-- 출력예) Europe Americas Asia Middle East and Africa
--		 x명

SELECT COUNT (*) AS Total,
       SUM (DECODE (E.region_name, 'Europe', 1, 0))
          AS "Europe",
       SUM (DECODE (E.region_name, 'Americas', 1, 0))
          AS "Americas",
       SUM (DECODE (E.region_name, 'Asia', 1, 0)) AS "Asia",
       SUM (DECODE (E.region_name, 'Middle East and Africa', 1, 0)) AS "Middle East and Africa"
  FROM employees A,
       departments B,
       locations C,
       countries D,
	   regions E
 WHERE     A.department_id = B.department_id
       AND B.location_id = C.location_id
       AND C.country_id = D.country_id
	   AND D.region_id = E.region_id;
	   
with
	region_dept as (
		select A.region_id, D.department_id
		from regions A, countries B, locations C, departments D
		where A.region_id = B.region_id
		and B.country_id = C.country_id
		and C.location_id = D.location_id
	)
	select sum(decode(B.region_id, 1, 1, 0)) as "Europe",
		sum(decode(B.region_id, 2, 1, 0)) as "Americas",
		sum(decode(B.region_id, 3, 1, 0)) as "Asia",
		sum(decode(B.region_id, 4, 1, 0)) as "Middle East and Africa"
	from employees A, region_dept B
	where A.department_id = B.department_id;
