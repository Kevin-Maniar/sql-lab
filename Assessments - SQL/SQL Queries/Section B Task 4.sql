use foodapp_db;
drop table if exists customers;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(50) NOT NULL,
    wallet_balance DECIMAL(10,2) NOT NULL
);

INSERT INTO customers (customer_name, wallet_balance)
VALUES
('Varun', 1000.00),
('Rahul', 500.00),
('Amit', 2000.00);

SELECT * FROM customers;

DESC restaurants;


drop procedure if exists place_order;

DELIMITER //

CREATE PROCEDURE place_order(
    IN p_customer_id INT,
    IN p_restaurant_id INT,
    IN p_amount DECIMAL(10,2)
)
BEGIN

    DECLARE v_balance DECIMAL(10,2);
    DECLARE v_customer_name VARCHAR(50);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT wallet_balance, customer_name
    INTO v_balance, v_customer_name
    FROM customers
    WHERE customer_id = p_customer_id
    FOR UPDATE;

    IF v_balance >= p_amount THEN

        UPDATE customers
        SET wallet_balance = wallet_balance - p_amount
        WHERE customer_id = p_customer_id;

        INSERT INTO orders
        (restaurants_id, customer_name, total_amount, order_date)
        VALUES
        (p_restaurant_id, v_customer_name, p_amount, CURDATE());

        COMMIT;

        SELECT 'Order placed successfully!' AS message;

    ELSE

        ROLLBACK;

        SELECT 'Insufficient wallet balance!' AS message;

    END IF;

END //

DELIMITER ;

CALL place_order(1, 1, 300);
CALL place_order(1, 1, 900);

SELECT * FROM customers;

SELECT * FROM orders;
