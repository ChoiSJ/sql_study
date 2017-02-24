-- Steven 과 같은 부서에서 일하는 사원을 조회하기
-- 1. Steven 의 부서번호 조회하기
select department_id
from employees
where first_name = 'Steven' and last_name = 'King';
-- 2. 90번 부서에 소속된 사원 조회하기
select first_name
from employees
where department_id = 90;

select first_name
from employees
where department_id = (select department_id
					   from employees
					   where first_name = 'Steven');
--					   and last_name = 'King');
-- 서브쿼리(내부쿼리) : 메인쿼리에서 사용될 값을 반환하는 쿼리
--				    메인쿼리에서 검색조건으로 사용될 값을 제공하는 쿼리

-- Tayler Fox 와 같은 부서에서 일하는 사원 중에서 Tayler 사원보다 급여를 많이 받는 사원의 이름과 급여를 조회하기
select first_name, salary
from employees
where department_id = (select department_id
					   from employees
					   where first_name = 'Tayler' 
					   and last_name = 'Fox')
and salary >= (select salary
			  from employees
			  where first_name = 'Tayler' 
			  and last_name = 'Fox');
			  

select first_name, salary
from employees
where salary > (select lowest_sal
			      from job_grades
			      where gra = 'B')
and salary < (select highest_sal
	 		  from job_grades
	 		  where gra = 'B');

-- 'Shipping' 부서에 일하는 사원의 아이디와 이름 조회하기
select employee_id, first_name
from employees
where department_id = (select department_id
					   from departments
					   where department_name = 'Shipping');
					   
-- 'Toronto' 에서 근무하는 사원의 이름을 조회하기
select first_name
from employees
where department_id = (select department_id
					   from departments
					   where location_id = (select location_id
					   					    from locations
											where city = 'Toronto'));
											
select last_name, department_name
from employees join departments
using (department_id);

-- 부서별로 인원수를 조회하기
select department_id, count(*)
from employees
group by department_id
having count(*) < 3
order by department_id;

-- 부서별로 인원수를 조회하고, 가장 인원수가 많은 부서와 그 인원수를 표시하기
select department_id, count(*)
from employees
group by department_id
having count(*) = (select max(count(*))
				   from employees
				   group by department_id);
				   
-- from 절에서 사용되는 서브쿼리
select name, salary, annual_salary
from (select first_name as name,
			 salary as salary,
			 salary*12 + salary*12*nvl(commission_pct, 0) as annual_salary
	  from employees)
where annual_salary >= 200000;

-- 'Steven' 과 같은 부서에 근무하는 사원과 부서아이디 조회하기
select first_name, department_id
from employees
where department_id in (select department_id
						from employees
						where first_name = 'Steven');

select first_name, department_id
from employees
where first_name = 'Steven';

-- IT_PROG 직종에 종사하는 사람들보다 급여를 적게 받는 사원을 조회하기
-- (IT_PROG 직종의 최고급여보다 적게 받는 사원 조회하기)
select first_name, salary
from employees
where job_id <> 'IT_PROG'
and salary < any (select salary
				  from employees
				  where job_id = 'IT_PROG');

select first_name, salary
from employees
where job_id <> 'IT_PROG'
and salary < (select max(salary)
			  from employees
			  where job_id = 'IT_PROG');

-- (IT_PROG 직종의 최고급여보다 적게 받는 사원 조회하기)
select first_name, salary
from employees
where job_id <> 'IT_PROG'
and salary < all (select salary
				  from employees
				  where job_id = 'IT_PROG');

select first_name, salary
from employees
where job_id <> 'IT_PROG'
and salary < (select min(salary)
			  from employees
			  where job_id = 'IT_PROG');
			  
-- 1. 'Adam' 과 같은 부서에 속한 사원들의 이름과 입사일을 조회하기
select first_name, hire_date
from employees
where department_id = (select department_id
					   from employees
					   where first_name = 'Adam'); 

-- 2. 급여가 사원전체 평균급여보다 많은 사원들의 사원아이디, 이름, 급여를 조회하기
select employee_id, first_name, salary
from employees
where salary >= (select avg(salary)
				 from employees);

-- 3. 이름에 'u'가 포함된 사원과 같은 부서에서 일하는 사원들의 아이디, 이름을 조회하기
select employee_id, first_name
from employees
where department_id in (select department_id
					    from employees
					    where first_name like '%u%');

-- 4. 부서 위치아이디가 1700인 부서에 소속된 모든 사원의 이름, 부서아이디, 업무아이디를 조회하기
select first_name, department_id, job_id
from employees
where department_id in (select department_id
					    from departments
					    where location_id = 1700);

-- 5. 'Steven King' 에게 보고하는 모든 사원의 아이디와 이름을 조회하기
select employee_id, first_name
from employees
where manager_id = (select employee_id
					from employees
					where first_name = 'Steven'
					and last_name = 'King');

-- 6. 'Executive' 부서에 소속된 사원의 부서번호, 사원이름, 업무아이디를 조회하기
select department_id, first_name, job_id
from employees
where department_id = (select department_id
					   from departments
					   where department_name = 'Executive');

-- 7. 'Toronto' 에서 근무하는 사원의 아이디, 이름, 부서이름, 급여를 조회하기
select E.employee_id, E.first_name, D.department_name, E.salary
from employees E, departments D
where E.department_id = D.department_id
and D.location_id = (select location_id
					   from locations
					   where city = 'Toronto');

-- 8. 부서별로 인원수를 조사했을 때 인원수가 가장 많은 부서에 근무하는 사원의 이름을 조회하기
select first_name
from employees
where department_id = (select department_id
					   from employees
					   group by department_id
					   having count(*) = (select max(count(department_id))
					  					  from employees
					   					  group by department_id));


--insert into 테이블명 (컬럼명, 컬럼명, 컬러명)
--values			(값, 값, 값, ...);
insert into tb_book(no, title, author, publisher, price, pubdate)
values(100, '자바의 정석', '신용권', '한빛미디어', 35000, sysdate);

commit;

-- 행의 모든 컬럼에 값을 입력하는 경우는 컬럼명부분을 생략할 수 있다.
-- 컬럼명부분을 생략했을 때는 테이블의 컬럼순서와 같은 순서로 값을 나열해야 한다.
insert into tb_book
values(101, '이것이 자바다', '남궁성', '도우출판사', 28000, sysdate);

commit;

-- 행의 일부 컬럼에만 값을 입력하는 경우 컬럼부분을 생략할 수 있다.
-- 생략한 컬럼명에는 null 이 들어간다.
insert into tb_book(no, title, author, price)
values(102, 'JSP 2.2', '오정원', 30000);

commit;

insert into tb_book(no, title, author, publisher, price, pubdate)
values(103, 'C언어 기초+', '윤인성', '교학사', 30000, null);

commit;

update tb_book
set publisher = '위키북스'
where no = 102;

update tb_book
set publisher = '제이펍',
	pubdate = sysdate
where no = 102;

commit;

delete from tb_book
where no = 102;

commit;

delete from departments
where department_id = 10;
