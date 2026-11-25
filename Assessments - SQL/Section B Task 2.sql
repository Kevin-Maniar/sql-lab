use foodapp_db;
drop database if exists orders;
create table orders (
orders_id int auto_increment primary key,
restaurants_id int not null,
customer_name varchar(25) not null, 
total_amount int not null, 
order_date date not null,
foreign key (restaurants_id) references restaurants(restaurants_id));

select * from restaurants;

INSERT INTO orders (restaurants_id, customer_name, total_amount, order_date) VALUES
(1, 'Rohan Patel', 500, '2026-11-01'),
(1, 'Kartik Patel', 330, '2026-11-02'),
(2, 'Joshna Patel', 100, '2026-11-03'),
(3, 'Smit Patel', 440, '2026-11-04'),
(4, 'Harry Patel', 900, '2026-11-01'),
(2, 'Anshika Patel', 1000, '2026-11-02'),
(1, 'Jiya Patel', 200, '2026-11-01'),
(5, 'Diya Patel', 180, '2026-11-01'),
(5, 'Priya Patel', 200, '2026-11-02'),
(1, 'Koyal Patel', 200, '2026-11-02'),
(5,'Rajesh Patel',250,'2026-11-01'),
(4,'Jethalal',150,'2026-11-01');

select 
	restaurants_id, 
    sum(total_amount) as revenue 
from orders 
group by restaurants_id;

select
	restaurants_id,
    sum(total_amount) as revenue 
from orders
group by restaurants_id having sum(total_amount > 5000);

select *
from orders 
order by order_date desc limit 5;
