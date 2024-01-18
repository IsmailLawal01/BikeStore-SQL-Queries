--Extract necessary details required to resolve a complaint from pamella Newman about an order made on 2018-04-16
        --finding the order details
SELECT * FROM sales.orders
WHERE order_date = '2018-08-23';
                    -- the customer has customer_id=10
                    -- store_id = 2
                    -- order_id = 1609

        -- finding all relevant details regarding the order
SELECT 
        customers.first_name||' '||customers.last_name AS full_name,
        customers.phone,
        customers.email,
        customers.street||' '||customers.city AS address,
        stores.store_name,
        products.product_name,
        stocks.quantity AS quantity_in_stock,
		orders.order_id,
        order_status,
        staffs.first_name||' '||staffs.last_name AS staff_name,
        staffs.phone
FROM
    sales.order_items
LEFT JOIN sales.orders ON order_items.order_id = orders.order_id
LEFT JOIN sales.customers ON orders.customer_id = customers.customer_id
LEFT JOIN sales.stores ON orders.store_id = stores.store_id
LEFT JOIN production.products ON  order_items.product_id = products.product_id
LEFT JOIN production.stocks ON products.product_id = stocks.product_id
INNER JOIN sales.staffs ON orders.staff_id = staffs.staff_id
WHERE orders.order_id = 1609 AND stocks.store_id = 2
GROUP BY orders.order_id,
		full_name,
        customers.phone,
        customers.email,
        address,
       stores.store_name,
        products.product_name,
		quantity_in_stock,
		order_status,
		staff_name,
        staffs.phone;