-- select
declare
	-- 변수 선언
	v_no	sample_customer.cust_no%type;
	v_name	sample_customer.cust_name%type;
begin
	select cust_no, cust_name
	into v_no, v_name
	from sample_customer
	where cust_no = 11;
	
	dbms_output.put_line(v_no || ', ' || v_name);
end;
/

declare
	v_no number(4) := &NO;
	v_name varchar2(50);
	v_grade varchar2(50);
	v_point number(8);
begin
	select cust_name, cust_grade, cust_point
	into v_name, v_grade, v_point
	from sample_customer
	where cust_no = v_no;
	
	dbms_output.put_line(v_no || ',' || v_name || ',' || v_grade || ',' || v_point);
end;

-- 고객이 결제했다.
-- 결제정보 저장 + 고객의 포인트 증가
declare
	i_type sample_payment.pay_type%type			:= '&type';
	i_amount sample_payment.pay_amount%type		:= '&amount';
	i_custno sample_payment.cust_no%type		:= '&custno';
begin
	-- 결제정보 저장
	insert into sample_payment (pay_no, pay_type, pay_amount, cust_no)
	values (pay_seq.nextval, i_type, i_amount, i_custno);
	
	-- 고객의 포인트 변경
	update sample_customer
	set
		cust_point = cust_point + (i_amount * 0.01)
	where
		cust_no = i_custno;
		
	-- db 에 반영
	commit;
	
	-- 콘솔에 결과 출력
	dbms_output.put_line('결제정보 저장 완료');
end;

declare
	i_custno	number(4)	:= '&custno';
	v_cust		sample_customer%rowtype;
	
begin
	select cust_no, cust_name, cust_grade, cust_point
	into v_cust
	from sample_customer
	where cust_no = i_custno;
	
	dbms_output.put_line(v_cust.cust_no || ' ' || v_cust.cust_name);
end;

declare
	-- 사용자정의 컬럼들로 구성된 레코드타입 만들기
	type my_record is record	-- my record 라는 타입 정의하기
	(
		id		employees.employee_id%type,
		name		employees.first_name%type,
		deptname	departments.department_name%type
	);
	
	v_emp	my_record;			-- my_record 타입의 변수 정의
begin
	select employee_id, first_name, department_name
	into v_emp
	from employees A, departments B
	where A.department_id = B.department_id
	and A.employee_id = '&no';
	
	dbms_output.put_line(v_emp.id || ' ' || v_emp.name || ' ' || v_emp.deptname);
end;

declare
	v_grade sample_customer.cust_grade%type;
begin
	select cust_grade
	into v_grade
	from sample_customer
	where cust_no = '&no';
	
	if (v_grade = '골드') then dbms_output.put_line('5% 적립');
	elsif (v_grade = '실버') then dbms_output.put_line('3% 적립');
	elsif (v_grade = '브론즈') then dbms_output.put_line('2% 적립');
	else dbms_output.put_line('적립없음');	
	
	end if;
end;

declare
	v_num number(2) := 1;
begin
	--while v_num <= 5 loop
	--	dbms_output.put_line(v_num);
	--	v_num := v_num + 1;
	--end loop;
	
	for i in 1..5 loop
		dbms_output.put_line(i);
	end loop;
end;

declare 
	v_cust sample_customer%rowtype;
begin
	for i in 11..14 loop
		select cust_no, cust_name, cust_grade, cust_point
		into v_cust
		from sample_customer
		where cust_no = i;
		
		dbms_output.put_line(v_cust.cust_name || ' ' || v_cust.cust_grade);
	end loop;
end;

declare
	-- 커서 선언
	cursor my_cursor is
		select cust_no, cust_name, cust_grade, cust_point
		from sample_customer
		where cust_no = 11;
	v_no number(4);
	v_name varcher(50);
begin
		-- 커서 열기
		open my_cursor;
		-- 커서에서 데이터 추출
		fetch my_cursor into v_no, v_name;		
		dbms_output.put_line(v_no || ' ' || v_name);
		-- 커서 닫기		
		close my_cursor;
end;

declare
	cursor emp_cl is
		select salary, first_name
		from employees;
		
	v_sum employees.salary%type := 0;
begin 
	for salary_rec in emp_cl loop
		dbms_output.put_line(salary_rec.first_name || ' ' || salary_rec.salary);
		v_sum := v_sum + salary_rec.salary;
	end loop;
	
	dbms_output.put_line('급여총액:' || v_sum);
end;

-- 파라미터가 있는 커서
-- 부서에 소속된 사람들의 이름, 급여 출력하기
declare
	param_dept_id employees.department_id%type := '&deptno';
	
	cursor emp_cl (i_dept_id employees.department_id%type) is
		select first_name, salary
		from employees
		where department_id = i_dept_id;
begin
	for emp in emp_cl(param_dept_id) loop
		dbms_output.put_line(emp.first_name || ' ' || emp.salary);
	end loop;
end;

-- 커서를 사용해서 sample_customer 에서 등급이 골드인 고객만 출력하기
declare
	cursor cust_cl is
		select cust_name, cust_grade, cust_point
		from sample_customer;
begin
	for cust in cust_cl loop
		if (cust.cust_grade = '골드') then dbms_output.put_line(cust.cust_name);
		end if; 
	end loop;
end;

create or replace procedure update_point
(v_cust_no in number, v_point in number)
is

begin
	update sample_customer
	set cust_point = cust_point + v_point
	where cust_no = v_cust_no;
	commit;
end;
/

create or replace procedure print_sum_salary (i_dept_id in number)
is
	v_sum employees.salary%type := 0;
	
	cursor emp_cl is
		select salary
		from employees
		where department_id = i_dept_id;
begin
	for emp in emp_cl loop
		v_sum := v_sum + emp.salary;
	end loop;
	
	dbms_output.put_line(i_dept_id || '부서의 급여 총합:' || v_sum);
end;
/

-- 고객이 결제하면 결제 정보를 저장하고, 포인트를 증가시킨다.
create or replace procedure add_pay
(i_custno sample_payment.cust_no%type,
i_type sample_payment.pay_type%type,
i_amount sample_payment.pay_amount%type)
is
	v_grade sample_customer.cust_grade%type;
	v_pointrate number;
begin
	-- 결제 정보 저장
	insert into sample_payment (pay_no, pay_type, pay_amount, cust_no)
	values (pay_seq.nextval, i_type, i_amount, i_custno);
	dbms_output.put_line('결제 정보 저장');

	-- 고객의 등급을 조회하기
	select cust_grade into v_grade
	from sample_customer
	where cust_no = i_custno;
	dbms_output.put_line('등급:' || v_grade);
	
	-- 포인트 지급률 알아내기
	if (v_grade = '골드') then v_pointrate := 0.05;
elsif (v_grade = '실버') then v_pointrate := 0.03;
elsif (v_grade = '브론즈') then v_pointrate := 0.01;
end if;
	dbms_output.put_line('포인트 지급률:' || v_pointrate);
	
	-- 고객의 포인트를 증가시키기
	update sample_customer
	set cust_point = cust_point + round(i_amount * v_pointrate)
	where cust_no = i_custno;
	dbms_output.put_line('고객 포인트 변경');
	
	commit;
	dbms_output.put_line('고객 포인트 변경');
end;

create or replace function ann_salary
(i_empid employees.department_id%type)
	return number
is
	v_annual_salary employees.salary%type;
begin
	select salary*12 + salary*12*nvl(commission_pct, 0) into v_annual_salary
	from employees
	where employee_id = i_empid;
	
	return v_annual_salary;
end;

create or replace trigger update_point_tr
after
insert on sample_payment
for each row
declare
	v_grade sample_customer.cust_grade%type;
	v_pointrate number;
begin
	-- 새로 추가된 결제정보의 고객번호에 해당하는 고객의 등급 조회하기
	select cust_grade into v_grade
	from sample_customer
	where cust_no = :new.cust_no;
	
	-- 포인트 적립률 계산
	if (v_grade = '골드') then v_pointrate := 0.05;
elsif (v_grade = '실버') then v_pointrate := 0.03;
elsif (v_grade = '브론즈') then v_pointrate := 0.01;
end if;

	-- 고객의 포인트를 변경
	update sample_customer
	set cust_point = cust_point + round(:new.pay_amount * v_pointrate)
	where cust_no = :new.cust_no;
end;