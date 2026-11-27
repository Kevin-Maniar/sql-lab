drop database if exists FoodDelivery_db;
create database FoodDelivery_db;
use FoodDelivery_db;

create table restaurants (
	restaurant_id int primary key auto_increment,
    name varchar(100) not null,
    city varchar (50) not null,
    cuisine_type varchar(50) not null,
    created_at timestamp default current_timestamp
);

create table menu_items (
	item_id int primary key auto_increment,
    restaurant_id int not null,
	item_name varchar(100) not null,
    price decimal(10,2) not null,
    category varchar(50) not null,
    foreign key (restaurant_id) 
    references restaurants(restaurant_id)
);

create table orders (
	order_id int primary key auto_increment,
    customer_name varchar(50) not null,
    restaurant_id int not null,
    item_id int not null,
	quantity int not null,
    total_amount decimal(10,2) not null,
    order_date datetime default current_timestamp,
    foreign key (restaurant_id) 
    references restaurants(restaurant_id),
    foreign key (item_id) 
    references menu_items(item_id)
);

create table order_audit(
	order_id int,
    restaurant_id int,
    action varchar(20),
    log_time datetime
);

INSERT INTO restaurants (name, city, cuisine_type)
VALUES
('Spice Hub', 'Rajkot', 'Indian'),
('Pizza Point', 'Ahmedabad', 'Italian'),
('Dragon Kitchen', 'Surat', 'Chinese');

INSERT INTO menu_items
(restaurant_id, item_name, price, category)
VALUES
(1, 'Paneer Tikka', 250, 'Starter'),
(1, 'Veg Biryani', 200, 'Main Course'),
(1, 'Gulab Jamun', 80, 'Dessert'),
(1, 'Masala Chai', 40, 'Beverage'),
(1, 'Paneer Butter Masala', 280, 'Main Course'),

(2, 'Margherita Pizza', 299, 'Main Course'),
(2, 'Garlic Bread', 150, 'Starter'),
(2, 'Chocolate Brownie', 120, 'Dessert'),
(2, 'Cold Coffee', 100, 'Beverage'),
(2, 'Farmhouse Pizza', 399, 'Main Course'),

(3, 'Spring Rolls', 180, 'Starter'),
(3, 'Veg Fried Rice', 220, 'Main Course'),
(3, 'Ice Cream', 90, 'Dessert'),
(3, 'Lemon Iced Tea', 70, 'Beverage'),
(3, 'Hakka Noodles', 210, 'Main Course');

INSERT INTO orders
(customer_name, restaurant_id, item_id, quantity, total_amount)
VALUES
('Rahul', 1, 1, 2, 500),
('Amit', 1, 2, 1, 200),
('Priya', 1, 3, 3, 240),
('Neha', 1, 4, 2, 80),
('Karan', 1, 5, 1, 280),

('Riya', 2, 6, 1, 299),
('Dev', 2, 7, 2, 300),
('Ankit', 2, 8, 1, 120),
('Meera', 2, 9, 2, 200),
('Raj', 2, 10, 1, 399),

('Jay', 3, 11, 2, 360),
('Simran', 3, 12, 1, 220),
('Vishal', 3, 13, 2, 180),
('Pooja', 3, 14, 3, 210),
('Arjun', 3, 15, 1, 210);

SELECT * FROM restaurants;
SELECT * FROM menu_items;
SELECT * FROM orders;

drop view if exists restaurant_sales_summary;
CREATE VIEW restaurant_sales_summary AS
SELECT
    r.name AS restaurant_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_revenue
FROM restaurants r
INNER JOIN orders o
    ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_id, r.name;

SELECT * FROM restaurant_sales_summary;


drop procedure if exists add_order;

DELIMITER //

CREATE PROCEDURE add_order(
    IN p_customer_name VARCHAR(50),
    IN p_restaurant_id INT,
    IN p_item_id INT,
    IN p_quantity INT
)
BEGIN

    DECLARE v_price DECIMAL(10,2);
    DECLARE v_total DECIMAL(10,2);
    DECLARE v_count INT;

    -- Rollback if any SQL error occurs
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Step 1: Check whether restaurant exists

    SELECT COUNT(*)
    INTO v_count
    FROM restaurants
    WHERE restaurant_id = p_restaurant_id;

    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Restaurant does not exist';
    END IF;


    -- Step 2: Check whether menu item belongs to restaurant

    SELECT COUNT(*)
    INTO v_count
    FROM menu_items
    WHERE item_id = p_item_id
      AND restaurant_id = p_restaurant_id;

    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid menu item for this restaurant';
    END IF;


    -- Step 3: Validate quantity

    IF p_quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity must be greater than zero';
    END IF;


    -- Step 4: Get menu item price

    SELECT price
    INTO v_price
    FROM menu_items
    WHERE item_id = p_item_id
      AND restaurant_id = p_restaurant_id;


    -- Step 5: Calculate total amount

    SET v_total = v_price * p_quantity;


    -- Step 6: Insert order

    INSERT INTO orders (
        customer_name,
        restaurant_id,
        item_id,
        quantity,
        total_amount
    )
    VALUES (
        p_customer_name,
        p_restaurant_id,
        p_item_id,
        p_quantity,
        v_total
    );


    -- Step 7: Commit transaction

    COMMIT;

END //

DELIMITER ;

-- Testing Procedure 

CALL add_order('Rahul', 1, 2, 3);
-- Verify the inserted order:
SELECT * FROM orders
ORDER BY order_id DESC
LIMIT 1;

-- Creating Trigger 

DELIMITER //

CREATE TRIGGER after_order_insert
AFTER INSERT ON orders
FOR EACH ROW
BEGIN

    INSERT INTO order_audit (
        order_id,
        restaurant_id,
        action,
        log_time
    )
    VALUES (
        NEW.order_id,
        NEW.restaurant_id,
        'INSERT',
        NOW()
    );

END //

DELIMITER ;

-- And check the audit log (once we've created the trigger):

SELECT * FROM order_audit
ORDER BY log_time DESC;







