select *
from employees E, departments D;

-- 사원아이디, 사원이름, 소속부서아이디, 소속부서이름 조회하기
select A.employee_id, A.first_name, A.department_id, B.department_id, B.department_name
from employees A, DEPARTMENTS B
where A.department_id = B.department_id;

-- 부서 아이디, 부서명, 주소, 우편번호, 도시명
select D.department_id, D.department_name, L.postal_code, L.city
from departments D, LOCATIONS L
where D.location_id = L.location_id;

-- 부서아이디, 부서명, 그리고 그 부서 관리자의 이름 조회하기
select D.department_id, D.department_name, D.manager_id, E.first_name
from departments D, employees E
where D.manager_id = E.employee_id
order by D.department_id;

-- 사원의 아이디, 사원이름, 그 사원이 소석된 부서이름, 그 사원이 담당하는 업무의 상세이름을 표시하기
select E.employee_id, E.first_name, D.department_name, J.job_id, J.job_title
from employees E, departments D, jobs J
where E.department_id = D.department_id
and E.job_id = J.job_id
order by E.employee_id;

-- 부서아이디, 부서명, 그 부서의 소재 도시명과 나라 이름 조회하기
select D.department_id, D.department_name, L.city, C.country_name
from departments D, locations L, countries C
where D.location_id = L.location_id
and L.country_id = C.country_id
order by D.department_id;

select E.employee_id	emp_id,		-- 사원아이디
		E.first_name	emp_name,	-- 사원이름
		M.employee_id	mng_id,		-- 상사아이디
		M.first_name	mng_name	-- 상사이름
from employees E, employees M
where E.manager_id = M.employee_id
order by E.employee_id;

-- 새로운 테이블 생성하기
CREATE TABLE JOB_GRADES (
	GRA CHAR(1),
	LOWEST_SAL NUMBER(8, 2),
	HIGHEST_SAL NUMBER(8, 2)
);

DELETE FROM JOB_GRADES;
INSERT INTO JOB_GRADES VALUES('A', 1000, 2999);
INSERT INTO JOB_GRADES VALUES('B', 3000, 5999);
INSERT INTO JOB_GRADES VALUES('C', 6000, 9999);
INSERT INTO JOB_GRADES VALUES('D', 10000, 14999);
INSERT INTO JOB_GRADES VALUES('E', 15000, 24999);
INSERT INTO JOB_GRADES VALUES('F', 25000, 40000);
COMMIT;

select *
from job_grades;

-- 사원아이디, 사원명, 급여, 그 급여에 해당하는 등급을 조회하기
select E.employee_id, E.first_name, E.salary, J.gra
from employees E, job_grades J 
where E.salary >= J.lowest_sal
and E.salary <= J.highest_sal
order by E.employee_id;

select A.first_name, A.department_id, B.department_name
from employees A, departments B
where A.department_id = B.department_id(+);

-- 1. 모든 사원의 이름, 부서아이디, 부서이름을 표시하기
select E.first_name, D.department_id, D.department_name
from employees E, departments D
where D.department_id = E.department_id;

-- 2. 커미션을 받는 모든 사원의 이름, 부서이름, 위치아이디 및 도시명을 표시하기
select E.first_name, D.department_name, D.location_id, L.city
from employees E, departments D, locations L
where E.department_id = D.department_id
and D.location_id = L.location_id
and E.commission_pct is not null;

-- 3. 이름에 a가 포함된 모든 사원의 이름과 부서이름 표시하기
select first_name, department_name
from employees E, departments D
where E.department_id = D.department_id
and first_name like '%a%';

-- 4. Toronto 에 근무하는 모든 사원의 이름, 업무, 부서번호 빛 부서이름을 표시하기
select E.first_name, J.job_title, D.department_id, D.department_name
from employees E, jobs J, departments D, locations L
where E.department_id = D.department_id
and E.job_id = J.job_id
and D.location_id = L.location_id
and L.city = 'Toronto';

-- 5. 사원의 이름과 사원아이디와 그 사원을 관리하는 상사의 사원아이디와 사원이름을 표시하기
select E.first_name, E.employee_id, M.employee_id, M.first_name
from employees E, employees M
where M.employee_id = E.manager_id;

-- 6. 모든 사원의 이름, 업무, 부서이름, 급여, 급여등급을 표시하기
select E.first_name, J.job_title, D.department_name, E.salary, G.gra
from employees E, jobs J, departments D, job_grades G
where E.department_id(+) = D.department_id
and J.job_id = E.job_id
and E.salary between G.lowest_sal and G.highest_sal;

-- 7. 본인의 상사보다 먼저 입사한 사원의 이름, 입사일, 관리자의 이름 및 입사일을 표시하기
select E.first_name, E.hire_date, M.first_name, M.hire_date
from employees E, employees M
where E.manager_id = M.employee_id
and E.hire_date < M.hire_date;
