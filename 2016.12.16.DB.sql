select sum(salary), avg(salary), min(salary), max(salary)
from employees;

select sum(commission_pct), avg(commission_pct),
		min(commission_pct), max(commission_pct)
from employees;

-- employees 테이블의 모든 행의 갯수 조회
select count(*)
from employees;

select count(*)
from employees
where commission_pct is null;

select count(*)
from employees
where job_id = 'ST_MAN';


-- employees 테이블에서 commisstion_pct 컬럼의 값이 null 이 아닌 행의 갯수를 조회한다.
select count(commission_pct)
from employees;

-- employees 테이블에서 사원들이 종사하고 있는 업무의 갯수를 조사하기
select count(distinct job_id)
from employees;

-- 60번 부서에서 일하는 사람들의 최소급여, 최고급여를 조회하기
select max(salary), min(salary)
from employees
where department_id = 60;

-- 60번 부서에서 일하는 사람의 평균급여를 조회하기
select avg(salary)
from employees
where department_id = 60;

-- 10, 20, 30, 40번 부서에서 일하는 사람들의 급여합계를 조회하기
select sum(salary)
from employees
where department_id in (10, 20, 30, 40);

-- 커미션을 받는 사람들의 급여평균을 조회하기
select avg(salary)
from employees
where commission_pct is not null;

-- 60번 부서에서 일하는 사람의 인원수 조회하기
select count(*)
from employees
where department_id = 60;

-- Toronto에 위치한 부서에서 일하는 사원의 인원수
select count(*)
from employees E, departments D, locations L
where E.department_id = D.department_id
and D.location_id = L.location_id
and L.city = 'Toronto';

-- 2005년 이후에 입사한 사원의 인원수
select count(*)
from employees
where to_number(to_char(hire_date, 'yyyy')) > 2005;

select count(*)
from employees
where hire_date > to_date('2006/01/01', 'yyyy/mm/dd');

-- 입사일이 오늘인 사원의 인원수
select count(*)
from employees
where to_char(sysdate, 'mm/dd') = to_char(E.hire_date, 'mm/dd');

-- 12월달에 입사한 사원의 인원수
select count(*)
from employees
where to_char(hire_date, 'mm') = '12';

select count(*)
from employees
group by job_id;

select job_id, count(*)
from employees
group by job_id;

-- 부서별 급여 합계를 구하기, 부서아이디와 급여 합계
select department_id, sum(salary)
from employees
group by department_id
having department_id = 50
order by department_id asc;

-- 부서별 근무 인원수를 조회하기 (부서아이디, 인원수표시)
select department_id, count(*)
from employees
group by department_id;

-- 부서별 근무 인원수를 조회하기 (부서이름, 인원수표시)
select D.department_name, count(*)
from employees E, departments D
where E.department_id = D.department_id
group by D.department_name;

-- 부서별 근무 인원수를 조회하기 (부서 이름, 인원수표시)
-- 단, 인원수가 20명 이상인 부서만 표시하기
select D.department_name, count(*)
from employees E, departments D
where E.department_id = D.department_id
group by D.department_name
having  count(*) >= 20;

-- 부서별로 인원수를 조회하기, 가장 많은 인원수를 가진 부서는?
select max(count(*))
from employees
group by department_id;

select salary, count(*)
from employees
group by salary
order by salary;

select trunc(salary/1000), salary
from employees;

select trunc(salary/1000) as "연봉 (단위:천달러)", 
	   count(*) as "인원수"
from employees
group by trunc(salary/1000)
order by 1;

-- 1. 50번 부서에 근무하는 인원수 조회하기
select department_id, count(*)
from employees
where department_id = 50
group by department_id;

-- 2. 모든 사원들의 최고급여액, 최저급여액, 급여총액, 평균급여액 조회하기
select max(salary), min(salary), sum(salary), avg(salary)
from employees;

-- 3. 업무별로 사원들의 최고급여액, 최저급여액, 급여총액, 평균급여액 조회하기
select job_id, max(salary), min(salary), sum(salary), avg(salary)
from employees
group by job_id;

-- 4. 동일한 업무에 종사하는 사원들의 수를 업무별로 표시하기
select job_id, count(*)
from employees
group by job_id;

-- 5. 사원들 중에서 관리자인 사원들의 인원수 조회하기(숫자만 표시)
select count(*)
from employees E, departments D
where E.employee_id = D.manager_id;

select count(distinct manager_id)
from employees;

-- 6. 50번 부서의 최고급여액과 최저급여액의 차액을 조회하기
select department_id, max(salary) - min(salary)
from employees
where department_id = 50
group by department_id;

-- 7. 관리자 아이디와 해당 관리자에 속한 사람들의 인원수를 표시하기
select manager_id, count(*)
from employees
group by manager_id;

-- 8. 관리자 아이디와 해당 관리자에 속한 사원들의 최저급여를 표시하기
-- (관리자가 지정되지 않은 사원과 최저급여가 6000달러 미만의 그룹은 제외하기)
select manager_id, min(salary)
from employees
where manager_id is not null
group by manager_id
having min(salary) > 6000; 

-- 9. 부서별 부서이름과 사원수, 부서내 사원들의 평균급여를 표시하기
-- (평균급여는 소숫점 2번째 자리로 반올림하기, 부서이름순으로 정렬)
select D.department_name, count(*), round(avg(salary), 2)
from employees E, departments D
where E.department_id = D.department_id
group by D.department_name
order by D.department_name;


-- 10. 입사년도별로 입사한 사원수를 표시하기
select to_char(hire_date, 'yyyy') as "year", count(*)
from employees
group by to_char(hire_date, 'yyyy')
order by "year";

select
	nvl(department_id, 0),
	count(*) as "Total", 
	sum(decode(to_char(hire_date, 'yyyy'), '2001', 1, 0)) as "2001",
	sum(decode(to_char(hire_date, 'yyyy'), '2002', 1, 0)) as "2002",
	sum(decode(to_char(hire_date, 'yyyy'), '2003', 1, 0)) as "2003"
from employees
group by department_id
order by department_id;