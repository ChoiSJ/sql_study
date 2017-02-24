CREATE TABLE TB_STUDENT (
	NO NUMBER(3)		constraint stud_no_pk 	primary key,
	NAME VARCHAR2(100)	constraint stud_name_nn not null,
	MAJOR VARCHAR2(100),
	GRADE NUMBER(1)		constraint stud_grade_ck check (grade in (1, 2, 3, 4)),
	PHONE VARCHAR(20)	constraint stud_phone_uk unique
);

create table TB_PROFESSOR (
	NO NUMBER(3),
	NAME VARCHAR(100)	constraint prof_name_nn not null,
	MAJOR VARCHAR(100)	constraint prof_major_nn not null,
	POSITION VARCHAR(50),
	PHONE VARCHAR(20),
	constraint prof_no_pk primary key (no),
	constraint prof_phone_uk unique (phone)
);

create table TB_SUBJECT (
	NO NUMBER(3)		constraint sub_no_pk primary key,
	NAME VARCHAR2(500)	constraint sub_name_nn not null,
	LIMIT NUMBER(3)		constraint sub_limit_ck check (limit > 0),
	PROF_NO NUMBER(3)	constraint sub_prof_no_fk references tb_professor (no),
	TYPE VARCHAR2(10)	constraint sub_type_ck check (type in ('전공', '교양'))
);

create table TB_COURSE (
	STUD_NO NUMBER(3),
	SUBJ_NO NUMBER(3),
	REGDATE DATE default sysdate, 
	
	constraints course_studno_fk foreign key (stud_no) references tb_student (no),
	constraints course_subjno_fk foreign key (subj_no) references tb_subject (no),
	constraints course_pk primary key (stud_no, subj_no)
);

insert into tb_student(no, name, grade, major, phone)
values(10, '홍길동', 2, '컴퓨터공학', '010-1234-5678');
insert into tb_student(no, name, grade, major, phone)
values(11, '이순신', 3, '기계공학', '010-4567-5678');
insert into tb_student(no, name, grade, major, phone)
values(12, '김유신', 4, '전기공학', '010-1234-1111');
insert into tb_student(no, name, grade, major, phone)
values(13, '강감찬', 4, '컴퓨터공학', '010-1234-3456');

commit;

insert into tb_subject(no, name, prof_no, limit, type)
values(100, '프로그램 언어 기초', 20, 50, '전공');
insert into tb_subject(no, name, prof_no, limit, type)
values(101, '공업수학', 22, 10, '전공');
insert into tb_subject(no, name, prof_no, limit, type)
values(102, '전기전자 기초실험', 22, 15, '전공');
insert into tb_subject(no, name, prof_no, limit, type)
values(103, '이산수학', 21, 30, '전공');
insert into tb_subject(no, name, prof_no, limit, type)
values(104, '암호학 기초', 21, 50, '전공');
insert into tb_subject(no, name, prof_no, limit, type)
values(105, '웹기초', 20, 100, '교양');

insert into tb_course(stud_no, subj_no)
values(10, 100);
insert into tb_course(stud_no, subj_no)
values(10, 101);
insert into tb_course(stud_no, subj_no)
values(10, 105);

insert into tb_course(stud_no, subj_no)
values(11, 100);
insert into tb_course(stud_no, subj_no)
values(11, 101);
insert into tb_course(stud_no, subj_no)
values(11, 104);

insert into tb_course(stud_no, subj_no)
values(12, 101);
insert into tb_course(stud_no, subj_no)
values(12, 102);

insert into tb_course(stud_no, subj_no)
values(13, 103);
insert into tb_course(stud_no, subj_no)
values(13, 104);
insert into tb_course(stud_no, subj_no)
values(13, 105);

-- 10번 학생이 수강 중인 과목의 과목번호와 과목명, 수강인원을 조회하기
select S.no, S.name, S.limit
from tb_subject S, tb_course C
where C.subj_no = S.no
and C.stud_no = 10;

select no, name, limit
from tb_subject
where no in (select subj_no
			 from tb_course
			 where stud_no = 10);

-- 20번 교수가 담당하는 과목을 수강중인 학생수를 표시하기
select count(distinct stud_no)
from tb_course
where subj_no in (select no
				  from tb_subject
				  where prof_no = 20);

-- 수강정보 표시하기
-- 과목번호, 과목명, 담당교수 이름, 정원, 수강신청한 학생의 학번과 이름
select C.subj_no as subject_no, 
	   S.name as subject_name, 
	   P.name as professor_name, 
	   S.limit as limit, 
	   C.stud_no as student_no, 
	   T.name as student_name
from tb_subject S, tb_course C, tb_student T, tb_professor P
where S.prof_no = P.no
and C.stud_no = T.no
and C.subj_no = S.no

-- 이산수학을 수강하는 학생정보를 조회하기
-- 학번, 학년, 이름, 전공을 표시하기
select no, grade, name, major
from tb_student
where no in (select stud_no
			 from tb_course
			 where subj_no = (select no
				 			  from tb_subject
				 			  where name = '이산수학'));

-- 각 과목별로 수강 가능 인원(몇명이 수강가능인원인가)
-- 과목번호, 과목명, 정원, 현재수강인원, 수강가능인원
select A.subj_no as 과목번호,
	   B.name as 과목명,
	   B.limit as 정원,
	   A.cnt as "현재 수강인원",
	   B.limit - A.cnt as "수강가능 인원"
from (select subj_no, count(*) cnt
	  from tb_course
	  group by subj_no) A, tb_subject B
where A.subj_no = B.no;
