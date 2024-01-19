SELECT 
        orders.order_id,
        order_date,
        CASE WHEN order_status = 3 THEN 'REJECTED' ELSE ' ' END AS status,
        customers.first_name||' '||customers.last_name AS customer_name,
        customers.phone AS customer_contact,
        customers.email AS customer_email,
        customers.street||' '||customers.city AS customer_address,
		customers.state,
		store_name,
		staffs.first_name||' '||staffs.last_name AS staff_name,
		staffs.phone AS staff_contact,
		products.product_name,
		order_items.revenue
FROM 
    sales.orders
INNER JOIN sales.customers ON orders.customer_id = customers.customer_id
INNER JOIN sales.stores ON orders.store_id = stores.store_id
INNER JOIN sales.staffs ON orders.staff_id = staffs.staff_id
INNER JOIN sales.order_items ON orders.order_id = order_items.order_id
INNER JOIN production.products ON order_items.product_id = products.product_id
WHERE order_status = 3
GROUP BY orders.order_id,
        order_date,
        customer_name,
		customer_contact,
		customer_email,
		customer_address,
		customers.state,
		store_name,
		staff_name,
		staff_contact,
		products.product_name,
		order_items.revenue
ORDER BY order_date DESC;