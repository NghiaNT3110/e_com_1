  /* Tạo bảng mới dùng CTE */
WITH
  order_details AS (
  SELECT
    DISTINCT inventory_item_id, /* Chọn Item ID trong kho không trùng vì mỗi Order ID gắn liền với Item ID trong kho */ 
    orders.order_id, /* Chọn Order ID */ 
    users.first_name ||" "|| users.last_name AS full_name, /* Gộp họ và tên thành đầy đủ họ tên */ 
    
    /* Chọn các trường thông tin về người dùng và traffic */ 
    users.email,
    users.age,
    users.city,
    users.state,
    users.country,
    order_items.status,
    traffic_source, 
    sale_price,

    inventory_items.cost, /* Chọn giá bán và chi phí nhập hàng */ 
    orders.num_of_item, /* Số lượng item được người dùng đặt mua trong đơn hàng */ 
    /* Tính toán chi phí, doanh thu và lơi nhuận */ 
    inventory_items.cost * orders.num_of_item AS total_product_cost, /* Chi phí */ 
    orders.num_of_item * sale_price AS total_revenue_purchase,/* Doanh thu */ 
    orders.num_of_item * (sale_price - inventory_items.cost) AS profit, /* Lợi nhuận */ 
    
    /* Chọn các trường thông tin về phân loại sản phẩm và tên sản phẩm */ 
    inventory_items.product_category,
    inventory_items.product_name,

    /* Chọn trường phân loại sản phẩm và tên sản phẩm */ 
    inventory_items.product_department,
    inventory_items.product_brand,
    /* Chọn giới tính theo sản phẩm và thương hiệu sản phẩm */ 
    
    /* Chọn các trường thông tin liên quan đến vòng đời ngày của đơn hàng */ 
    order_items.created_at,
    order_items.shipped_at,
    order_items.delivered_at,
    order_items.returned_at,

    /* Tính toán số tiền bị hoàn đơn */
    CASE
      WHEN order_items.status LIKE '%Return%' OR order_items.status LIKE '%Cancel%' /* Khi trạng thái của đơn giống hoàn đơn hoặc hủy đơn */ THEN orders.num_of_item * sale_price
    ELSE
    0 /* Nếu không phải 2 trạng thái đó thì mặc định là 0 */
  END
    AS total_return,

  
    /* Tính toán khoảng cách ngày để xử lý đơn hàng, giao đơn hàng, trả đơn hàng sau khi nhận được hàng */ 
    ABS(DATE_DIFF(order_items.delivered_at, order_items.shipped_at, DAY)) AS delivery_time_in_days,
    ABS(DATE_DIFF(order_items.shipped_at, order_items.created_at, DAY)) AS process_time_in_days,
    ABS(DATE_DIFF(order_items.returned_at, order_items.created_at, DAY)) AS return_after_received_days,
    inventory_items.product_distribution_center_id
  FROM
    big-query-378507.thelook_ecommerce.order_items /* Join bảng Users để lấy thông tin về các trường nhân khẩu học, traffic */
  LEFT OUTER JOIN
    big-query-378507.thelook_ecommerce.users
  ON
    users.id = order_items.user_id /* Join bảng inventory_items để lấy thông tin về các trường sản phẩm */
    
    RIGHT OUTER JOIN
    big-query-378507.thelook_ecommerce.orders
  ON
    orders.order_id = order_items.order_id /* Sắp xếp theo ngày tạo đơn hàng giảm dần*/
  RIGHT OUTER JOIN
    big-query-378507.thelook_ecommerce.inventory_items
  ON
    inventory_items.product_id = order_items.product_id /* Join bảng Orders để biết được trạng thái đơn hàng và doanh thu */
  
  ORDER BY
    order_items.created_at DESC ) /* JOIN bảng chi nhánh từ bảng CTE đã tạo */
SELECT
  o.*,
  d.name
FROM
  order_details o
JOIN
  big-query-378507.thelook_ecommerce.distribution_centers d
ON
  d.id = o.product_distribution_center_id
ORDER BY
    o.created_at DESC
