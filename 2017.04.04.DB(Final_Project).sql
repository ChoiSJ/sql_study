CREATE TABLE table_message
(
   message_no            NUMBER PRIMARY KEY,
   message_title         VARCHAR2 (50) NOT NULL,
   message_writer        VARCHAR2 (50) NOT NULL,
   message_description   VARCHAR2 (500),
   message_check         CHAR (1) DEFAULT 'N' NOT NULL,
   message_filename      VARCHAR2 (50),
   message_reddate       DATE NOT NULL,
   message_checkdate     DATE
);

create table table_message_receive (
	receive_no number primary key,
	receive_sender varchar2(50)	not null,
	receive_title varchar2(50) not null,
	receive_filename varchar2(50),
	receive_senddate date,
	receive_check char(1) default 'N' not null
);

create table table_message_send (
	send_no number primary key,
	send_receiver varchar2(50) not null,
	send_title varchar2(50) not null,
	send_recdate date not null,
	send_checkdate references table_message(message_checkdate),
	send_check char(1) default 'N' not null
);

