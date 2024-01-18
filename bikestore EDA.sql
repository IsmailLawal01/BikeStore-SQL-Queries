-- extracting information of all customers from New York.
SELECT 
		first_name ||' '|| last_name AS full_name,
		email,
		phone,
		street ||','|| city AS address
FROM sales.customers
WHERE state = 'NY'
ORDER BY full_name ASC;

	-- pinpointing those that have valid phone numbers.
SELECT 
		first_name ||' '|| last_name AS full_name,
		email,
		phone,
		street ||','|| city AS address
FROM sales.customers
WHERE state = 'NY' AND phone IS NOT NULL
ORDER BY full_name ASC;


--customers who ordered from baldwin bikes and santa cruz bikes store.
	-- from Santa Cruz Bikes
SELECT 
		first_name||' '||last_name AS full_name,
		customers.email,
		customers.phone,
        store_name
FROM sales.customers
INNER JOIN sales.orders ON customers.customer_id = orders.order_id
INNER JOIN sales.stores ON orders.store_id = stores.store_id
WHERE orders.store_id = 1
ORDER BY full_name ASC;

	--Baldwin Bikes
SELECT 
		first_name||' '||last_name AS full_name,
		customers.email,
		customers.phone,
        store_name
FROM sales.customers
INNER JOIN sales.orders ON customers.customer_id = orders.order_id
INNER JOIN sales.stores ON orders.store_id = stores.store_id
WHERE orders.store_id = 2
ORDER BY full_name ASC;


--items with 0.10 discount and above
SELECT 
		item_id,
		product_name AS item_name,
		discount
FROM sales.order_items
INNER JOIN production.products ON order_items.product_id = products.product_id
WHERE discount >= 0.10
GROUP BY item_id,
        product_name,
        discount
ORDER BY item_id ASC;


-- all time staff performance
        -- exploration for staff performance
    SELECT
	    staff_id,
	    COUNT(order_id)
    FROM sales.orders
    GROUP BY staff_id
    ORDER BY (COUNT(order_id)) DESC;
--returning details of the best performing staff and marking the top two Gold & Silver reapectively.
SELECT 
		orders.staff_id,
		first_name||' '||last_name AS full_name,
		staffs.email,
		staffs.phone,
		COUNT(order_id) AS sales_count,
		CASE WHEN COUNT(order_id)>550 THEN 'GOLD STAFF'
			WHEN COUNT(order_id)>500 THEN 'SILVER STAFF'
			ELSE ' ' END AS performance
FROM
	sales.orders
INNER JOIN sales.staffs ON orders.staff_id = staffs.staff_id
GROUP BY 
		orders.staff_id,
		full_name,
		staffs.email,
		staffs.phone
ORDER BY orders.staff_id ASC;

-- best performing staff for the year
    -- exploration
    SELECT
	    staff_id,
	    COUNT(order_id)
    FROM sales.orders
    WHERE (EXTRACT(YEAR FROM order_date)) = 2018
    GROUP BY staff_id
    ORDER BY (COUNT(order_id)) DESC;
--returing details of best performing staff for the year
SELECT 
		orders.staff_id,
		first_name||' '||last_name AS full_name,
		staffs.email,
		staffs.phone,
		COUNT(order_id) AS sales_count,
		CASE WHEN COUNT(order_id)>90 THEN 'BEST STAFF' ELSE ' ' END AS performance
FROM
	sales.orders
INNER JOIN sales.staffs ON orders.staff_id = staffs.staff_id
WHERE (EXTRACT(YEAR FROM order_date)) = 2018
GROUP BY 
		orders.staff_id,
		full_name,
		staffs.email,
		staffs.phone
ORDER BY orders.staff_id ASC;



--creating a revenue column
ALTER TABLE sales.order_items
ADD COLUMN revenue DECIMAL (10,2);

-- populating the column
UPDATE sales.order_items
SET revenue = quantity * (list_price - discount);


--revenue per customer
SELECT 
		orders.customer_id,
		first_name||' '||last_name AS full_name,
		SUM(revenue) AS net_spend
FROM
	sales.customers
INNER JOIN sales.orders ON customers.customer_id = orders.customer_id
INNER JOIN sales.order_items ON orders.order_id = order_items.order_id
GROUP BY orders.customer_id,
        full_name
ORDER BY net_spend DESC;


---top 10 bestselling product
SELECT 
		products.product_id,
		products.product_name,
		SUM(revenue) AS net_sales,
		CASE WHEN SUM(revenue) > 600000 THEN 'BEST SELLER' ELSE ' ' END AS performance
FROM
	production.products
INNER JOIN sales.order_items ON products.product_id = order_items.product_id
GROUP BY products.product_id,
		products.product_name
ORDER BY net_sales DESC LIMIT 10;