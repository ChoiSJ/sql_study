use my_db;

create table tb_books (
	id integer primary key auto_increment,
    title varchar(300) not null,
    author varchar(300) not null,
    publisher varchar(300) not null,
    price integer not null,
    description longtext,
    regdate date
);

insert into tb_books 
(title, author, publisher, price, description, regdate)
values 
('이것이 자바다', '신용권', '한빛미디어', 35000, '자바 기본서 최고 베스트셀러 책입니다.', now());

commit;

select title
from tb_books;