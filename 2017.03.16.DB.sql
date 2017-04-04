create database my_db;

show databases;

-- 실행할 때 반드시 이 쿼리문을 입력해야 한다.
use my_db;

create table tb_board (
	id integer primary key auto_increment,
    title varchar(200) not null,
    writer varchar(100) not null,
    contents varchar(100) not null,
    regdate date
);