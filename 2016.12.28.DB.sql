-- 소속된 사원이 1명 이상인 부서 찾기
select department_id, count(*)
from employees
group by department_id
having count(*) > 0;

-- 소속된 사원이 1명 이상인 부서 찾기
select department_id, department_name
from departments A
where exists (select 1
			from employees B
			where B.department_id = A.department_id);
			
-- 소속된 사원이 1명도 없는 부서 찾기
select department_id, department_name
from departments A
where not exists (select 1
				from employees B
				where B.department_id = A.department_id);

-- 샤원테이블에 10번 부서에 있는 사원이 존재하면 부서명 정보를 조회해라.				
select department_id, department_name
from departments
where department_id = 10
and exists (select 1
			from employees A
			where A.department_id = 10);
			
-- 부서별 평균을 조회하기
select department_id, avg(salary)
from employees
group by department_id;

-- 모든 사원들의 급여를 그 부서의 평균급여로 설정하기
update employees A
set salary = (select avg(salary)
			from employees B
			where B.department_id = A.department_id);

-- 100번 사원의 급여를 전체 사원의 평균급여보다 10000 달러 많게 변경학
update employees
set salary = (select avg(salary) + 10000
			from employees)
where employee_id = 100;

-- Curtis Davies 와 같은 급여를 받는 사람을 조회하기
select employee_id, first_name, salary
from employees
where salary = (select salary
				from employees
				where first_name = 'Curtis' and last_name = 'Davies');
				
-- Curtis Davies 와 같은 부서에서 일하고, 급여도 동일하게 지급받는 사원 찾기
select employee_id, first_name, salary, department_id
from employees
where salary = (select salary
				from employees
				where first_name = 'Curtis' and last_name = 'Davies')
and department_id = (select department_id
					from employees
					where first_name = 'Curtis' and last_name = 'Davies');
					
select employee_id, first_name, salary, department_id
from employees
where (department_id, salary) = (select department_id, salary
								from employees
								where first_name = 'Curtis' and last_name = 'Davies');

-- 101번 사원의 부하직원								
select lpad(employee_id, level*5, '-'), employee_id, first_name, manager_id
from employees
start with employee_id = 101
connect by prior employee_id = manager_id
and employee_id <> 108;
-- 부모키 employee_id
-- 자식키 manager_id
-- 부모행의 employee_id 값이 자식행의 manager_id 값과 같은 계층 관계를 검색한다.
-- employee_id 와 같은 값을 갖고 있는 manager_id 를 가진 행 찾아가기... >>> 자식행 찾기

-- 'Ismael' 의 상사를 조회
select employee_id, first_name, manager_id
from employees
where employee_id <> (select employee_id
					from employees
					where first_name = 'Ismael')
start with employee_id = (select employee_id
						from employees
						where first_name = 'Ismael')
connect by prior manager_id = employee_id;
-- manager_id 와 같은 값을 갖고 있는 employee_id 를 가진 행 찾아가기... >>> 부모행 찾기

-- Steven King 의 부하직원 조회하기
select employee_id, first_name, manager_id
from employees
start with employee_id = 100
connect by prior employee_id = manager_id;

-- 커미션을 받는 사원과 부서번호 및 급여가 일치하는 사원의 이름, 부서번호, 급여를 조회하기
select first_name, department_id, salary
from employees
where (department_id, salary) in (select department_id, salary
								from employees
								where commission_pct is not null);

-- 위치아이디가 1700인 지역에 근무하는 사원과 급여가 일치하는 사원의 이름, 부서이름, 및 급여를 조회하기
select A.first_name, B.department_name, A.salary
from employees A, departments B
where salary in (select salary
				from employees
				where department_id in (select department_id
										from departments
										where location_id = 1700))
and A.department_id = B.department_id;

-- 'Neena' 과 동일한 급여 및 커미션을 받는 모든 사원의 이름, 입사일, 급여를 조회하기
-- ('Neena' 표시하지 않는다.)
select first_name, hire_date, salary
from employees
where (salary, nvl(commission_pct, 0)) in (select salary, nvl(commission_pct, 0)
								from employees
								where first_name = 'Neena')
and first_name <> 'Neena';


-- job_id 가 ' SA_MAN' 인 사람들보다 급여를 많이 받는 사원의 이름, 직종, 급여를 조회하기
select first_name, job_id, salary
from employees
where salary > all (select salary
					from employees
					where job_id = 'SA_MAN');


-- 'T' 로 시작하는 도시에서 근무하는 사원의 이름, 소속부서 아이디를 조회하기
select first_name, department_id
from employees
where department_id = (select department_id
					from departments
					where location_id in (select location_id
										from locations
										where substr(city, 1, 1) = 'T'));

-- 소속부서의 평균급여보다 많은 급여를 받는 사원들의 이름, 급여, 부서아이디, 소속부서의 평균급여를 조회하기
select B.first_name, B.department_id, B.salary, A.avg
from (select department_id, avg(salary) avg
	from employees
	group by department_id) A, employees B
where A.avg < B.salary
and A.department_id = B.department_id;

with
	dept_avg_sal as (
		select department_id, avg(salary) avg_sal
		from employees
		group by department_id
	)
select first_name, salary, department_id,
	(select avg_sal
	from dept_avg_sal B
	where department_id = A.department_id) avg_sal
from employees A
where salary > (select avg_sal
				from dept_avg_sal B
				where B.department_id = A.department_id);

-- 총 급여가 전체 회사 총 급여의 1/8 보다 많은 부서의 이름을 조회하기
select A.department_id, A.department_name
from departments A,
	(select department_id, sum(salary)
	from employees
	group by department_id
	having sum(salary) > all (select sum(salary)/8
							from employees)) B
where A.department_id = B.department_id;