# e_com_1
Đây là dự án phân tích dữ liệu dựa trên tập dữ liệu E-Com trên Big Query của Google
Dưới đây là note về các trường data được Query ra:
+ inventory_item_id
+ orders.order_id
+ full_name
+ email
+ age
+ city
+ state
+ country
+ status
+ traffic_source
+ sale_price
+ inventory_items.cost
+ num_of_item
+ inventory_items.cost * orders.num_of_item as total_product_cost
+ orders.num_of_item * sale_price as total_revenue_purchase
+ orders.num_of_item * (sale_price - inventory_items.cost) as profit
+ inventory_items.product_category,inventory_items.product_name
+ inventory_items.product_department
+ created_at
+ shipped_at
+ delivered_at
+ returned_at
+ total_return
+ DATE_DIFF(order_items.delivered_at , order_items.created_at, DAY) as delivery_time_in_days
+ DATE_DIFF(order_items.shipped_at , order_items.created_at, DAY) as process_time_in_days
+ DATE_DIFF(order_items.returned_at , order_items.created_at, DAY) as return_after_received_days

FROM big-query-378507.thelook_ecommerce.order_items
  LEFT JOIN big-query-378507.thelook_ecommerce.users
  ON users.id = order_items.user_id

  RIGHT JOIN big-query-378507.thelook_ecommerce.inventory_items
  ON inventory_items.product_id = order_items.product_id 

  RIGHT JOIN big-query-378507.thelook_ecommerce.orders
  ON orders.order_id = order_items.order_id 
ORDER BY order_items.created_at DESC
