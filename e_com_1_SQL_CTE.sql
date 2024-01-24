/* Tạo bảng mới dùng CTE - Create new table using CTE */ 
WITH order_details AS (
  SELECT DISTINCT inventory_item_id, /* Chọn Item ID trong kho không trùng vì mỗi Order ID gắn liền với Item ID trong kho - Select and remove duplicate Item ID because each Order ID is sitck with Item ID */ 
  orders.order_id, /* Chọn Order ID - Seleclt Order ID */ 
  users.first_name ||" "|| users.last_name as full_name, /* Gộp họ và tên thành đầy đủ họ tên - Concancate First name and Last name into Full name */ 
  users.email, users.age, users.city,users.state,users.country,order_items.status,traffic_source, /* Chọn các trường thông tin về người dùng và traffic - Select fields about user info and traffic source */ 
  sale_price, inventory_items.cost, /* Chọn giá bán và chi phí nhập hàng - Seclect Sale price and Item Cost */
  orders.num_of_item, /* Số lượng item được người dùng đặt mua trong đơn hàng - Number of items that user purchase in the order */ 

/* Tính toán chi phí, doanh thu và lợi nhuận * - Calculate total cost, total revenue and total profit/

  inventory_items.cost * orders.num_of_item as total_product_cost, /* Chi phí - total cost */
  orders.num_of_item * sale_price as total_revenue_purchase, /* Doanh thu - total revenue */ 
  orders.num_of_item * (sale_price - inventory_items.cost) as profit, /* Lợi nhuận - total profit */ 

 /* Chọn các trường thông tin về phân loại sản phẩm và tên sản phẩm - Select fields about product categories and product name*/

  inventory_items.product_category,inventory_items.product_name, /* Chọn trường phân loại sản phẩm và tên sản phẩm * - Select product category and product name/
  inventory_items.product_department,inventory_items.product_brand, /* Chọn giới tính theo sản phẩm và thương hiệu sản phẩm * - Select gender and brand name of the product/ 

/* Chọn các trường thông tin liên quan đến vòng đời ngày của đơn hàng - Select fields related to order's life cycle */ 

  order_items.created_at, order_items.shipped_at,order_items.delivered_at,order_items.returned_at,

/* Tính toán số tiền bị hoàn đơn - Calculate revenue when the order status is Return or Cancel */ 

CASE 
WHEN order_items.status LIKE '%Return%' OR order_items.status LIKE '%Cancel%' /* Khi trạng thái của đơn giống hoàn đơn hoặc hủy đơn */
THEN orders.num_of_item * sale_price
else 0 /* Nếu không phải 2 trạng thái đó thì mặc định là 0 */ 
end as total_return,


/* Tính toán khoảng cách ngày để xử lý đơn hàng, giao đơn hàng, trả đơn hàng sau khi nhận được hàng - Calculate days between time stamp based on status */ 

ABS(DATE_DIFF(order_items.delivered_at , order_items.shipped_at, DAY)) as delivery_time_in_days, /* Thời gian giao hàng từ khi ra khỏi kho - Delivery time from leaving the warehouse */
ABS(DATE_DIFF(order_items.shipped_at , order_items.created_at, DAY)) as process_time_in_days, /* Thời gian xử lý đơn từ khi tạo đến khi ship - Processing time from order creation to shipment */
ABS(DATE_DIFF(order_items.returned_at , order_items.created_at, DAY)) as return_after_received_days /* Thời gian trả đơn sau khi nhận hàng - Time to return the order after receiving */

FROM big-query-378507.thelook_ecommerce.order_items /* Bảng chính được dùng - Primary table used for joining with other tables */ 

/* Join bảng Users để lấy thông tin về các trường nhân khẩu học, traffic - Join users table to get information about demographic, traffic source */
  LEFT JOIN big-query-378507.thelook_ecommerce.users
  ON users.id = order_items.user_id

/* Join bảng inventory_items để lấy thông tin về các trường sản phẩm - Join Inventory table to get information about product */ 
  RIGHT JOIN big-query-378507.thelook_ecommerce.inventory_items
  ON inventory_items.product_id = order_items.product_id 

/* Join bảng Orders để biết được trạng thái đơn hàng và doanh thu - Join Orders table to get information about order status and revenue */ 
  RIGHT JOIN big-query-378507.thelook_ecommerce.orders
  ON orders.order_id = order_items.order_id 

/* Sắp xếp theo ngày tạo đơn hàng giảm dần - Sort by the latest created order date */ 
ORDER BY order_items.created_at DESC
)
/* JOIN bảng chi nhánh từ bảng CTE đã tạo - Join distribution center table to get the branch's name and ID */
SELECT o.*, d.name
FROM order_details o 
JOIN big-query-378507.thelook_ecommerce.distribution_centers d
ON d.id = o.product_distribution_center_id
