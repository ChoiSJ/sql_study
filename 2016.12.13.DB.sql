-- employee 테이블에서 급여를 5000 달러 미만으로 받은 사원들의 사원 아이디, 이름, 급여를 조회하기
select employee_id, first_name, salary
from employees
where salary < 5000;

-- employee 테이블에서 담당매니저 아이디가 100번인 사원들의 사원아이디, 이름, 담당매니저 아이디를 조회하기
select employee_id, first_name, manager_id
from employees
where manager_id = 100;

-- employees 테이블에서 사원들이 소속된 부서아이디를 전부 표시하기(중복 없이)
select distinct job_id
from employees;

-- employees 테이블에서 소속부서 아이디가 60번 사원들의 사원아이디, 이름, 직종(job) 아이디, 소속부서 아이디를 조회하기
select employee_id, first_name, job_id, department_id
from employees
where department_id = 60;

-- 급여가 5000~6000 사이에 속하는 사원들의 아이디, 이름, 급여 조회하기
select employee_id, first_name, salary
from EMPLOYEES
where salary between 5000 and 6000;

select employee_id, first_name, salary
from EMPLOYEES
where salary >= 5000 and salary <= 6000;
-- -> 둘 다 결과는 같다.

--  지역아이디 3번, 4번에 속하는 나라이름, 지역아이디 출력하기
select country_name, country_id
from countries 
where region_id in (3, 4);

select country_name, country_id
from countries
where region_id = 3 or region_id = 4;
-- -> or 도 가능하지만 in 을 추천

select street_address, postal_code
from locations
where street_address like '%9%';

select employee_id, first_name, commission_pct
from employees
where commission_pct is null;

select employee_id, first_name, commission_pct
from employees
where commission_pct is not null;

-- employee 테이블에서 소속부서가 Shipping 부서에 소속되어 있고, 급여를 3000 달러 이상 받는 사원들의 사원아이디, 사원이름, 급여, 소속부서아이디를 조회하기
select employee_id, first_name, salary, department_id
from employees
where salary >= 3000 
and department_id = 50;

-- employees 테이블에서 50번 부서나 60번 부서에 소속된 사원 중에서 급여를 8000 달러 이상 받는 사원들의 사원아이디, 사원이름, 급여, 소속부터 아이디를 조회하기
select employee_id, first_name, salary, department_id
from employees
where salary >= 8000 
and department_id in (50, 60);

select employee_id, first_name, salary, department_id
from employees
where salary >= 8000 
and (department_id = 50 or department_id = 60);

select first_name, job_id, salary
from employees
order by first_name;

-- 급여를 10000달러 이상 받은 사람들의 이름, 직종, 급여를 조회하기(이름순으로 정렬)
select first_name, job_id, salary
from employees
where salary >= 10000
order by first_name desc;

-- employees 테이블에서 커미션을 받은 모든 사원의 사원이름, 직종, 급여, 커미션 조회하기
-- 급여, 커미션을 기준으로 정렬하기
select first_name, job_id, salary, commission_pct
from employees
where commission_pct is not null
order by salary asc, commission_pct asc;

select first_name, upper(first_name), lower(first_name)
from employees;

select lower( concat(first_name, last_name) )
from employees;

-- substr(컬럼 혹은 표현식, 시작위치, 갯수)	: 지정된 위치부터 갯수만큼 추출
-- substr(컬럼 혹은 표현식, 시작위치)	: 지정된 위치부터 끝까지 추출
select first_name, SUBSTR(first_name, 2, 2)
from employees;

select street_address, INSTR(street_address, ' '), substr(street_address, 1, INSTR(street_address, ' ')-1)
from locations
where location_id < 2500;

-- lpad(컬럼 혹은 표현식, 길이 '채울문자')
select first_name, salary, lpad('*', salary/1000, '*')
from employees;

select employees_seq.nextval
from dual;

select lpad(employees_seq.nextval, 10, '0')
from dual;

select *
from dual;

select replace('hello, java java java javajava', 'java', 'oracle')
from dual;

-- employees 테이블의 이름에서 a 혹은 A를 *로 바꾸기
select replace(replace(first_name, 'a', '*'), 'A', '*')
from employees;

select replace(substr(first_name, 1, 1), 'A', '*') || replace(substr(first_name, 2), 'a', '*')
from employees;

select distinct job_id
from employees;

select first_name || ' ' || job_id
from employees;

select first_name, salary
from employees
where salary > 12000;

select first_name, department_id
from employees
where employee_id = 176;

select first_name, salary
from employees
-- where salary < 5000 or salary > 12000;
where not(salary >= 5000 and salary <= 12000);

select first_name, department_id
from employees
where department_id in (20, 50);

select first_name, salary
from employees
where department_id in (20, 50) 
and salary between 5000 and 12000;

select first_name, job_id
from employees
where manager_id is null;

select first_name, salary, commission_pct
from employees
where commission_pct is not null
order by commission_pct desc;

select first_name
from employees
where substr(first_name, 3, 1) = 'a';

select first_name
from employees
where first_name like '%a%'
and first_name like '%e%';

-- round(컬럼 혹은 표현식)
-- round(컬럼 혹은 표현식, 자릿수)
-- 지정된 자리수까지 표시하고, 그 자리 아래에서 반올림한다.

-- trunc(컬럼 혹은 표현식)
-- trunc(컬럼 혹은 표현식, 자릿수)
-- 지정된 자리수까지 표시하고, 그 아래 자리를 잘라낸다.
select round(123.45), round(123.45, 1)
from dual;

select round(45.926, 0), round(45.926, -1)
from dual;

select TRUNC(45.926), TRUNC(45.926, -1)
from dual;

-- mod(숫자1, 숫자2)
-- 숫자1 을 숫자2 로 나눈 나머지를 반환한다.
select mod(13, 5)
from dual;

-- 커미션을 받는 사원들의 급여를 커미션을 포함시켜서 계산하기
select salary, commission_pct, trunc(salary + salary * commission_pct, -1) 
from EMPLOYEES
where commission_pct is not null;

-- 급여를 15000 ~ 15999 사이로 받는 사원의 이름과 급여를 조회하기
select first_name, salary
from EMPLOYEES
where trunc(salary, -3) = 2000;

select SYSDATE
from dual;

select SYSDATE + 31
from dual;

select first_name, trunc(sysdate - hire_date)
from employees;
