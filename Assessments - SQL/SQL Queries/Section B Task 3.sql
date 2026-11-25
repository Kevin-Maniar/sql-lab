use foodapp_db;

drop table if exists hotel;

create table hotel(
hotel_id int primary key auto_increment,
hotel_name varchar(50) not null,
hotel_city varchar (25) not null);

drop table if exists menu_itmes;
create table menu_itmes ( 
item_id int primary key auto_increment,
hotel_id int not null,
item_name varchar(30) not null,
price int not null,
category varchar(15) not null,
foreign key (hotel_id) references hotel(hotel_id));

insert into hotel (hotel_name, hotel_city) value 
('Waves','Rajkot'),
('The Fern','Rajkot'),
('Senso','Mumbai'),
('Saraza','Surat'),
('The Heritage Place','Baroda'),
('Patel Parotha House','Rajkot'),
('Shree Dosa','Mumbai');

insert into hotel (hotel_name,hotel_city) values ('Hotel nova','Rajkot');

describe menu_itmes;
select * from hotel;
insert into menu_itmes (hotel_id, item_name, price, category) values
-- Hotel 1
(1, 'Pizza', 180, 'Junk Food'),
(1, 'Burger', 90, 'Junk Food'),
(1, 'Pasta', 150, 'Italian'),
(1, 'Cold Coffee', 80, 'Beverage'),
(1, 'French Fries', 70, 'Junk Food'),

-- Hotel 2
(2, 'Burger', 110, 'Junk Food'),
(2, 'Sandwich', 80, 'Fast Food'),
(2, 'Paneer Tikka', 220, 'Starter'),
(2, 'Cold Coffee', 100, 'Beverage'),
(2, 'Masala Dosa', 100, 'South Indian'),

-- Hotel 3
(3, 'Pizza', 250, 'Junk Food'),
(3, 'Pav Bhaji', 120, 'Street Food'),
(3, 'Vada Pav', 30, 'Street Food'),
(3, 'Tea', 20, 'Beverage'),
(3, 'Burger', 100, 'Junk Food'),

-- Hotel 4
(4, 'Paneer Butter Masala', 240, 'Main Course'),
(4, 'Butter Naan', 40, 'Indian Bread'),
(4, 'Dal Tadka', 160, 'Main Course'),
(4, 'Jeera Rice', 120, 'Rice'),
(4, 'Cold Coffee', 90, 'Beverage'),

-- Hotel 5
(5, 'Veg Biryani', 180, 'Rice'),
(5, 'Pizza', 200, 'Junk Food'),
(5, 'French Fries', 80, 'Junk Food'),
(5, 'Manchurian', 140, 'Chinese'),
(5, 'Noodles', 130, 'Chinese'),

-- Hotel 6
(6, 'Masala Dosa', 90, 'South Indian'),
(6, 'Idli Sambar', 60, 'South Indian'),
(6, 'Tea', 15, 'Beverage'),
(6, 'Sandwich', 70, 'Fast Food'),
(6, 'Pasta', 160, 'Italian'),

-- Hotel 7
(7, 'Burger', 120, 'Junk Food'),
(7, 'Veg Biryani', 200, 'Rice'),
(7, 'Paneer Tikka', 250, 'Starter'),
(7, 'Noodles', 150, 'Chinese'),
(7, 'Lassi', 50, 'Beverage');

select * from menu_itmes;
select * from hotel;
describe hotel;
describe menu_itmes;

select 
	hotel_name,item_name,price
from hotel 
inner join
	menu_itmes on
hotel.hotel_id = menu_itmes.hotel_id;

select 
	hotel_name,hotel_city,item_name,category,price
from hotel 
left join
	menu_itmes on
hotel.hotel_id = menu_itmes.hotel_id;

drop view if exists hotel_summary;
create view hotel_summary as 
select 
	h.hotel_name, sum(m.item_id) as total_items  , round(avg(m.price))  as avg_price
from hotel h inner join menu_itmes m on h.hotel_id  = m.hotel_id group by h.hotel_id,h.hotel_name;

select * from hotel_summary;
 






