drop database if exists foodapp_db;
create database foodapp_db;
use foodapp_db;

create table restaurants (
restaurants_id int auto_increment primary key, 
name varchar(50) not null,
city varchar(20),
cuisine_type varchar (20),
rating decimal(3,1));

insert into restaurants (name,city,cuisine_type,rating) values 
('Saraza','Rajkot','Indian',4.4),
('Waves','Surat','Italian',3.4),
('The Grand Thakor','Rajkot','Indian',4.9),
('Senso','Baroda','Mexican',3.3),
('The heritage place','Baroda','Mexican',4.4),
('Big Bite','Surat','Chinese',5.0);

select * from restaurants;

update restaurants set rating = 4.1 where restaurants_id = 1;
delete from restaurants where restaurants_id = 6;