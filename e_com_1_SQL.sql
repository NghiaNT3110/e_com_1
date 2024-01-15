/* Lựa chọn các trường định vị đơn hàng (ID, trạng thái), nhân khẩu học, nguồn traffic từ các bảng thông tin */

SELECT DISTINCT inventory_item_id, 
  orders.order_id,
  users.first_name ||" "|| users.last_name as full_name, 
  users.email, users.age, users.city,users.state,users.country,order_items.status,traffic_source,
  sale_price, inventory_items.cost, 
  orders.num_of_item,

/* Tính toán chi phí, doanh thu và lơi nhuận */

  inventory_items.cost * orders.num_of_item as total_product_cost,
  orders.num_of_item * sale_price as total_revenue_purchase,
  orders.num_of_item * (sale_price - inventory_items.cost) as profit,

 /* Chọn các trường thông tin về phân loại sản phẩm và tên sản phẩm */

  inventory_items.product_category,inventory_items.product_name, 
  inventory_items.product_department, inventory_items.product_brand,

/* Chọn các trường thông tin liên quan đến vòng đời ngày của đơn hàng */ 

  order_items.created_at, order_items.shipped_at,order_items.delivered_at,order_items.returned_at,

/* Tính toán số tiền bị hoàn đơn */ 

CASE 
WHEN order_items.status LIKE '%Return%' OR order_items.status LIKE '%Cancel%'
THEN orders.num_of_item * sale_price
else 0
end as total_return,

/* Tính toán khoảng cách ngày để xử lý đơn hàng, giao đơn hàng, trả đơn hàng sau khi nhận được hàng */ 

DATE_DIFF(order_items.delivered_at , order_items.shipped_at, DAY) as delivery_time_in_days,
DATE_DIFF(order_items.shipped_at , order_items.created_at, DAY) as process_time_in_days,
DATE_DIFF(order_items.returned_at , order_items.created_at, DAY) as return_after_received_days

FROM big-query-378507.thelook_ecommerce.order_items

/* Join bảng Users để lấy thông tin về các trường nhân khẩu học, traffic */
  LEFT JOIN big-query-378507.thelook_ecommerce.users
  ON users.id = order_items.user_id

/* Join bảng inventory_items để lấy thông tin về các trường sản phẩm */ 
  RIGHT JOIN big-query-378507.thelook_ecommerce.inventory_items
  ON inventory_items.product_id = order_items.product_id 

/* Join bảng Orders để biết được trạng thái đơn hàng và doanh thu */ 
  RIGHT JOIN big-query-378507.thelook_ecommerce.orders
  ON orders.order_id = order_items.order_id 

/* Sắp xếp theo ngày tạo đơn hàng giảm dần*/ 
ORDER BY order_items.created_at DESC
