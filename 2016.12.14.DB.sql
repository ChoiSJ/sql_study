select first_name,							-- 이름
	   hire_date,							-- 입사일
	   MONTHS_BETWEEN(sysdate, hire_date)	-- 입사 후 경과 개월 수
from employees;

-- ADD_MONTH(날짜1, 개월수)
-- 날짜1에서 지정된 개월수만큼의 이전/이후의 날짜를 반환한다.
select ADD_MONTHS(sysdate, -5)
from dual;

-- LAST_DAY(sysdate)
-- 지정된 날짜가 속한 달의 마지막 날짜를 반환한다.
select LAST_DAY(sysdate)
from dual;

-- NEXT_DAY(날짜, '요일')
-- 지정된 날짜 이후의 날짜 중에서 해당 요일의 날짜를 반환한다.
select NEXT_DAY(sysdate, 3)
from dual;

select round(sysdate), trunc(sysdate)
from dual;

select to_date('1988-11', 'yyyy-mm')
from dual;

-- 날짜 - 날짜	: 일수
-- 날짜 + 숫자	: 숫자만큼 경과된 날짜
-- 날짜 - 숫자	: 숫자만큼 이전 날짜

select to_char(123456, '999,999')
from dual;

-- employees 테이블의 사원들의 급여를 3자리마다 ,를 추가해서 표시하기
select first_name, to_char(salary, 'L999,999')
from employees;

select first_name, to_char(commission_pct, '0.99')
from EMPLOYEES
where commission_pct is not null;

select to_char(1.32, '0.99')
from dual;

select '11' * 2
from dual;

-- to_number('숫자로 변환할 문자', '문자의 생김새')
select to_number('1,234', '9,999') * 2
from dual;

select to_char(sysdate, 'yyyy-mm-dd')
from dual;

select to_char(sysdate, 'hh:mi:ss')
from dual;

-- employees 테이블에서 월의 첫날에 입사한 사람의 이름, 입사일 조회하기
select first_name, hire_date
from EMPLOYEES
where to_char(hire_date, 'dd') = '01';

-- employees 테이블에서 월의 마지막날에 입사한 사람의 이름, 입사일 조회하기
select first_name, hire_date
from EMPLOYEES
where to_char(LAST_DAY(hire_date), 'mm-dd') = to_char(hire_date, 'mm-dd');

-- employees 테이블에서 2002년도 입사한 사람의 이름, 입사일 조회하기
select first_name, hire_date
from EMPLOYEES
where to_char(LAST_DAY(hire_date), 'yyyy') = '2002';

-- employees 테이블에서 입사일이 오늘인 사람의 이름, 입사일 조회하기
select first_name, hire_date
from EMPLOYEES
where to_char(sysdate, 'mm-dd') = to_char(hire_date, 'mm-dd');

-- TO_CHAR(날짜, '포맷문자')
-- 날짜를 지정한 포맷의 문자로 변환한다
-- 패턴 문자
-- 년	yyyy 	혹은 YYYY
-- 월	mm		혹은 MM
-- 일	dd		혹은 DD
-- 시	hh		혹은 HH, hh12, 혹은 HH12, hh24 혹은 HH24
-- 분	mi		혹은 MI
-- 초	ss		혹은 SS

-- TO_CHAR(날짜, '포맷문자')
-- 날짜를 지정한 포맷의 문자로 변환한다.
-- TO_DATE('날짜형식의 문자', '패턴')
-- '날짜형식의 문자'가 지정한 패턴과 일치할 때 그 문자를 날짜로 변환한다.
select to_date('2002/12/12', 'yyyy/mm/dd')
from dual;

select to_date('12-12', 'mm-dd')
from dual;

-- employees 테이블에서 2005년 이전에 입사한 사원의 이름, 입사일 조회하기
select first_name, hire_date
from employees
where hire_date < to_date('2005/01/01', 'yyyy/mm/dd');

select first_name, hire_date
from EMPLOYEES
where to_number(to_char(hire_date, 'yyyy')) < 2005;

-- 일반함수
-- nvl(null 값을 포함할 수 있는 컬럼 혹은 표현식, null 일 때 대체할 값)
-- nvl() 은 컬럼 혹은 표현식과 대체할 값을 데이터유형이 동일해야 한다.
-- nvl() 은 null 값을 포함하고 있는 값을 대상으로 산술연산을 수행할 때 사용
-- (* null 값은 어떤 값과 연산을 해도 무조건 null 이기 때문)

select commission_pct, nvl(commission_pct, 0)
from employees;

-- 연봉 계산하기
-- 연봉 = 급여*12 + 급여*12*commission_pct
-- employees 테이블에서 사원의 연봉을 계산해서 사원아이디, 사원이름, 급여, 커미션, 연봉을 표시하기
select employee_id, first_name, salary, commission_pct, salary*12 + salary*12*nvl(commission_pct, 0)
from EMPLOYEES;

-- 커미션을 받지 못하는 경우 "없음" 이라고 표시하기
select first_name, commission_pct, nvl(to_char(commission_pct, '0.99'), '없음')
from employees;

-- nvl2(컬럼 혹은 표현식, 표현식1, 표현식2)
-- 컬럼 혹은 표현식의 값이 null 이 아닌 경우에는 표현식1이, 컬럼 혹은 표현식의 값이 null 인 경우에는 표현식2가 반환된다.
select commission_pct, nvl2(commission_pct, '있음', '없음')
from EMPLOYEES;

select first_name, salary, commission_pct, salary*12 + nvl2(commission_pct, salary*12*commission_pct, 0)
from employees;

-- if문 흉내를 낼 수 있는 표현식
-- case문
-- case when 표현식1 then 반환값_표현식1
--		when 표현식2 then 반환값_표현식2
--		else 반환값_표현식
-- end
select CASE when 1 = 2 then 3
				when 1 = 1 then 4
		END
from dual;

-- 급여가 10000달러 이하는 급여 20% 인상, 20000달러 이하는 10% 인상
-- 그 외는 5% 인상된 급여를 사원이름, 급여, 인상된 급여 순으로 표현하기
select first_name, 
		salary,
		case 
			when salary <= 10000 then salary*1.2
			when salary <= 20000 then salary*1.1
			else salary*1.05
		end as "new salary"
from EMPLOYEES;

-- 부서아이디가 10, 20, 30, 40번인 경우 'A' 팀
-- 부서아이디가 50, 60		   번인 경우 'B' 팀
-- 그 외 부서는					    'C' 팀으로 표시하기
-- 사원 이름, 부서아이디, 팀명 순으로 표기하기
select first_name,
		department_id,
		case
			when department_id in (10, 20, 30, 40) then 'A'
			when department_id in (50, 60) then 'B'
			else 'C'
		end as team
from employees
order by team;

-- decode문
-- decode(컬럼 혹은 표현식, 표현식1, 결과식1,
--					    표현식2, 결과식2,
--					    표현식3, 결과식3,
--					    기본값);
-- 컬럼 혹은 표현식의 값이 표현식1과 일치하면 결과식1의 수행결과가 최종값이 되고,
-- 표현식2와 일치하면 결과식2의 수행결과가 최종값이 되고,
-- 표현식3과 일치하면 결과식3의 수행결과가 최종값이 되고,
-- 표현식1,표현식2,표현식3과 모두 일치하지 않으면 기본값이 최종값이 된다.
select first_name, department_id,
	decode(department_id,
						10, 'A',
						20, 'A',
						30, 'A',
						40, 'A',
						50, 'B',
						60, 'B',
						'C')
from employees;

select salary,
	decode(trunc(salary/1000, -1),
						20, '20000달러 이상지급자',
						10, '10000 ~ 19999달러 지급자',
						0, '10000달러 미만 지급자')
from employees;

-- 1. 현재 날짜를 표시하기(단, 2016.12.14 같은 형식으로 표시)
-- 2. 각 사원에 대해서 사원번호, 이름, 급여, 15% 인상된 급여를 표시하기
-- 3. 2번 문제에서 사원번호, 이름, 급여, 15% 인상된 급여, 인상된 급여와 현재급여의 차액을 표시하기
-- 4. 이름이 J, A 또는 M으로 시작하는 모든 사원들의 이름을 표시하기
-- 5. 각 사원의 이름과 입사일로부터 현재까지의 근무 달 수를 계산해서 표기하기(계산된 근무 달 수는 정수로 표시하고, 근무 달 수를 기준으로 정렬하기)
-- 6. 사원의 이름과 급여를 표시하고, 급여 총액을 *로 나타내기, 각 *은 1000달러를 나타낸다.
-- 7. decode 함수를 사용해서 업무 아이디에 따라서 사원의 등급을 표시하기
-- AD_PRES		A, ST_MAN		B, IT_PROG		C, SA_REP		D, ST_CLERK		E, 기타 Z
select to_char(sysdate, 'yyyy.mm.dd')
from dual;

select employee_id, first_name, salary, salary + salary*0.15
from employees;

select employee_id, first_name, salary, salary*1.15 as "new salary", salary*1.15 - salary
from employees;

select first_name
from employees
where substr(first_name, 1, 1) in ('A', 'J', 'M');

select first_name, trunc(MONTHS_BETWEEN(sysdate, hire_date)) as months
from employees
order by months;

select first_name, salary, lpad('*', salary/1000, '*')
from employees;

select job_id, first_name,
	decode(job_id, 'AD_PRES', 'A',
				   'ST_MAN', 'B',
				   'IT_PROG', 'C',
				   'SA_REP', 'D',
				   'ST_CLERK', 'E', 
				   'Z') as grade
from employees;
-- 서 업무 아이디에 따라서 사원의 등급을 표시하기
-- AD_PRES		A, ST_MAN		B, IT_PROG		C, SA_REP		D, ST_CLERK		E, 기타 Z
select to_char(sysdate, 'yyyy.mm.dd')
from dual;

select employee_id, first_name, salary, salary + salary*0.15
from employees;

select employee_id, first_name, salary, salary*1.15 as "new salary", salary*1.15 - salary
from employees;

select first_name
from employees
where substr(first_name, 1, 1) in ('A', 'J', 'M');

select first_name, trunc(MONTHS_BETWEEN(sysdate, hire_date)) as months
from employees
order by months;

select first_name, salary, lpad('*', salary/1000, '*')
from employees;

select job_id, first_name,
	decode(job_id, 'AD_PRES', 'A',
				   'ST_MAN', 'B',
				   'IT_PROG', 'C',
				   'SA_REP', 'D',
				   'ST_CLERK', 'E', 
				   'Z') as grade
 from employees;
