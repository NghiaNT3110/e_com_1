SELECT DISTINCT inventory_item_id, 
  orders.order_id,
  users.first_name ||" "|| users.last_name as full_name, 
  users.email, users.age, users.city,users.state,users.country,order_items.status,traffic_source,
  sale_price, inventory_items.cost, 
  orders.num_of_item,
  inventory_items.cost * orders.num_of_item as total_product_cost,
  orders.num_of_item * sale_price as total_revenue_purchase,
  orders.num_of_item * (sale_price - inventory_items.cost) as profit, 
  inventory_items.product_category,inventory_items.product_name, 
  inventory_items.product_department,
  order_items.created_at, order_items.shipped_at,order_items.delivered_at,order_items.returned_at,
CASE 
WHEN order_items.status LIKE '%Return%'THEN orders.num_of_item * sale_price
else NULL
end as total_return,
DATE_DIFF(order_items.delivered_at , order_items.created_at, DAY) as delivery_time_in_days,
DATE_DIFF(order_items.shipped_at , order_items.created_at, DAY) as process_time_in_days,
DATE_DIFF(order_items.returned_at , order_items.created_at, DAY) as return_after_received_days
FROM big-query-378507.thelook_ecommerce.order_items
  LEFT JOIN big-query-378507.thelook_ecommerce.users
  ON users.id = order_items.user_id

  RIGHT JOIN big-query-378507.thelook_ecommerce.inventory_items
  ON inventory_items.product_id = order_items.product_id 

  RIGHT JOIN big-query-378507.thelook_ecommerce.orders
  ON orders.order_id = order_items.order_id 
ORDER BY order_items.created_at DESC