-- ai augmented Store Procedure query


DELIMITER //

drop procedure if exists restaurant_monthly_summary; -- added so i can run query again
CREATE PROCEDURE restaurant_monthly_summary(
    IN p_restaurant_id INT,
    IN p_month INT
)
BEGIN

    -- Validate month number
    IF p_month < 1 OR p_month > 12 THEN

        SELECT 'Invalid month number. Enter a month between 1 and 12.'
        AS message;

    ELSE

        -- Check whether orders exist
        IF NOT EXISTS (
            SELECT 1
            FROM orders
            WHERE restaurant_id = p_restaurant_id
              AND MONTH(order_date) = p_month
              AND YEAR(order_date) = YEAR(CURDATE())
        ) THEN

            SELECT CONCAT(
                'No orders found for restaurant ID ',
                p_restaurant_id,
                ' in month ',
                p_month,
                ' of ',
                YEAR(CURDATE())
            ) AS message;

        ELSE

            -- Generate monthly summary
            SELECT
                restaurant_id,
                COUNT(order_id) AS total_orders,
                SUM(total_amount) AS total_revenue,
                ROUND(AVG(total_amount), 2) AS avg_order_value

            FROM orders

            WHERE restaurant_id = p_restaurant_id
              AND MONTH(order_date) = p_month
              AND YEAR(order_date) = YEAR(CURDATE())

            GROUP BY restaurant_id;

        END IF;

    END IF;

END //

DELIMITER ;

CALL restaurant_monthly_summary(1, 11);
CALL restaurant_monthly_summary(2, 12);