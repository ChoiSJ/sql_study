select rowid, employee_id, first_name
from employees;

select rowid, no, name
from tb_student;

-- 학생 테이블의 이름 컬럼의 값을 기준으로 인덱스 생성
create index stud_name_idx
on tb_student (name);

-- 편의점의 매출테이블의 판매일자를 기준으로 인덱스 생성
-- 날짜의 역순으로 인덱스를 생성하는 것이 유리하다.
create index store_selldate_idx
on tb_store (selldata desc);

-- 판매일자를 '년/월/일' 형태로 자주 조회한다면 
-- where절에서 자주 사용되는 형태와 동일한 형태로 값을 변형해서 생성한다.
create index store_selldate_idx
on tb_store (to_char(selldate, 'yyyy/mm/dd') desc);

-- 편의점 매출을 조회할 때 거의 대부분 지점코드와 날짜로 자주 조회한다면
-- 지점코드와 날짜를 묶어서 인덱스를 생성한다.
create index store_sell_index
on th_store (store_code, to_char(selldate, 'yyyy/mm/dd') desc);

-- 두 개 이상의 컬럼을 묶어서 인덱스를 생성하기
create index prof_name_idx
on tb_professor (major, name);

-- 인덱스 삭제
drop index prof_name_idx;

select *
from user_indexes;

-- 신규 사용자 생성
create user hta
identified by zxcv1234;

-- 신규 사용자 생성
create user hta
identified by zxcv1234
default tablespace users
temporary tablespace temp;

-- 신규 사용자에게 시스템 권한 부여하기
grant resource, create session, create table, create sequence, create view
to hta;

-- 롤을 이용한 권한 부여
create role developer;

grant resource, create session, create table, create sequence, create view
to developer;

grant developer
to hta;

-- 권한 부여 및 취소
grant select
on employees
to hta;

revoke select
on employees
from hta;

-- 뷰를 이용한 권한 부여
create or replace view emp_simple_view
as
	select employee_id, first_name, job_id, department_id
	from employees;
	
grant select
on emp_simple_view
to hta;

-- 전체 부서의 평균 총급여보다, 총급여가 많은 부서의 이름, 총급여를 표시하기
with
	cost_dept as (
		-- 부서별 총급여
		select B.department_name, sum(salary) dept_salary
		from employees A, departments B
		where A.department_id = B.department_id
		group by B.department_name
	),
	cost_avg as (
		-- 전체 부서 평균 급여
		select sum(dept_salary)/count(*) total_avg_salary
		from cost_dept
	)
select department_name, dept_salary, (select total_avg_salary from cost_avg)
from cost_dept
where dept_salary > (select total_avg_salary from cost_avg);

-- 급여순으로 정렬했을 때 1등~3등 이내, 11~13등, 21~23등을 조회
with
	salary_ranking as (
		select rank() over (order by salary desc) ranking,
			first_name,
			salary
		from employees
	)
select ranking, first_name, salary
from salary_ranking
where ranking <= 3
union
select ranking, first_name, salary
from salary_ranking
where ranking between 11 and 13;