# e_com_1
Đây là dự án phân tích dữ liệu dựa trên tập dữ liệu E-Com trên Big Query của Google - This is a E-com DA project based on E-com Dataset in Bigquery Public Dataset (Thelook_ecom)
Dưới đây là note về các trường data được Query ra: - Here're notes about queried fields: 
+ inventory_item_id: ID của sản phẩm ở trong kho - Product ID of the item in storage. 
+ order_id: ID của đơn hàng - Order ID 
+ full_name: Họ tên đầy đủ của người hàng - Full name of the user
+ email: Email của người đặt hàng - Email of the user
+ age: Tuổi của người đặt hàng - Age of the user 
+ city: Thành phố đang ở của người đặt hàng - The city where the user lives and receives orders.
+ state: Bang đang ở của người đặt hàng - The state where the user lives and receives orders.
+ country: Quốc gia đang ở của người đặt hàng - The country where the user lives and  orders.
+ status: Trạng thái đơn hàng (Đang xử lý, đang giao, đã giao, hủy đơn, hoàn đơn) - Status of the order (Processing, Shipped, Deliveried, Cancelled, Returned) 
+ traffic_source: Nguồn traffic mà KH đặt hàng trên Website (Email, Facebook Ads, Google Ads, Organic) - Traffic Source where the user purchase products (Email, Facebook Ads, Google Ads, Organic) 
+ sale_price: Giá bán sản phẩm trên thị trường - Sale price of the product on the Market
+ inventory_items.cost: Chi phí sản xuất/nhập sản phẩm về - Original Price or Buying Cost of the product 
+ num_of_item: Số lượng item mà người đặt hàng đặt ở trong đơn - Number of the item that the user purchase in the order 
+ inventory_items.cost * orders.num_of_item as total_product_cost: Tổng chi phí sản xuất/nhập hàng về của DN - Total cost
+ orders.num_of_item * sale_price as total_revenue_purchase: Tổng doanh thu từ việc đặt đơn hàng - Total Revenue 
+ orders.num_of_item * (sale_price - inventory_items.cost) as profit: Lợi nhuận còn lại sau khi lấy doanh thu trừ đi chi phí - Total Profit
+ inventory_items.product_category: Phân loại sản phẩm (Quần Jeans, Áo len, Áo khoác,...) - Product Category (Jeans, Sweater, Coats,...)
+ inventory_items.product_name: Tên chi tiết của sản phẩm đó  - Detailed name of the product 
+ inventory_items.product_department: Loại sản phẩm dành cho ai (Nam, nữ) - Gender of the product that user purchase 
+ created_at: Ngày tạo đơn hàng (Có thể tạo được sau khi ship đơn hàng và người đặt hàng đã nhận được đơn hàng) - Order created date (Can be created even after the order being shipped or received/returned) 
+ shipped_at: Ngày giao hàng từ kho - The day when the order shipped from the storage 
+ delivered_at: Ngày người đặt hàng nhận được đơn hàng - The day when the user receive the order
+ returned_at: Ngày người đặt hàng trả lại đơn hàng - The day when the user return the order 
+ total_return: Tổng doanh thu từ các đơn hàng có trạng thái hoàn đơn, hủy đơn (Return, Cancel) - Total Revenue from orders with the status "Return" or "Cancel" 
+ DATE_DIFF(order_items.delivered_at , order_items.shipped_at, DAY) as delivery_time_in_days: Khoảng cách ngày từ lúc hàng ra khỏi kho đến lúc người đặt hàng nhận được đơn hàng - Delivery time from leaving the warehouse 
+ DATE_DIFF(order_items.shipped_at , order_items.created_at, DAY) as process_time_in_days: Khoảng cách ngày từ lúc xử lý đơn hàng trên hệ thống đến lúc đơn hàng ra khỏi kho - Processing time from order creation to shipment 
+ DATE_DIFF(order_items.returned_at , order_items.created_at, DAY) as return_after_received_days: Khoảng cách ngày từ lúc xử lý đơn hàng trên hệ thống đến lúc đơn hàng được trả lại - Time to return the order after receiving

FROM big-query-378507.thelook_ecommerce.order_items - Bảng gốc được dùng: Order Item - Primary table used for joining with other tables 
  LEFT JOIN big-query-378507.thelook_ecommerce.users - Bảng dùng để join đầu tiên lấy thông tin nhân khẩu học: Users - The first table joined to get demographic information. 
  ON users.id = order_items.user_id

  RIGHT JOIN big-query-378507.thelook_ecommerce.inventory_items - Bảng dùng để join lần 2 lấy thông tin về sản phẩm - Inventory Items  - The second table joined to get product information 
  ON inventory_items.product_id = order_items.product_id 

  RIGHT JOIN big-query-378507.thelook_ecommerce.orders - Bảng dùng để join lần 3 lấy thông tin về đơn hàng - Orders - The last table joined to get order information
  ON orders.order_id = order_items.order_id 
ORDER BY order_items.created_at DESC - Sắp xếp thứ tự theo ngày tạo đơn hàng để theo dõi theo ngày mới - Sort by the latest created date. 
