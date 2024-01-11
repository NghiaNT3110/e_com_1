# e_com_1
Đây là dự án phân tích dữ liệu dựa trên tập dữ liệu E-Com trên Big Query của Google
Dưới đây là note về các trường data được Query ra:
+ inventory_item_id
+ order_id: ID của đơn hàng
+ full_name: Họ tên đầy đủ của người hàng
+ email: Email của người đặt hàng
+ age: Tuổi của người đặt hàng
+ city: Thành phố đang ở của người đặt hàng
+ state: Bang đang ở của người đặt hàng
+ country: Quốc gia đang ở của người đặt hàng
+ status: Trạng thái đơn hàng (Đang xử lý, đang giao, đã giao, hủy đơn, hoàn đơn)
+ traffic_source: Nguồn traffic mà KH đặt hàng trên Website (Email, Facebook Ads, Google Ads, Organic)
+ sale_price: Giá bán sản phẩm trên thị trường
+ inventory_items.cost: Chi phí sản xuất/nhập sản phẩm về
+ num_of_item: Số lượng item mà người đặt hàng đặt ở trong đơn
+ inventory_items.cost * orders.num_of_item as total_product_cost: Tổng chi phí sản xuất/nhập hàng về của DN
+ orders.num_of_item * sale_price as total_revenue_purchase: Tổng doanh thu từ việc đặt đơn hàng 
+ orders.num_of_item * (sale_price - inventory_items.cost) as profit: Lợi nhuận còn lại sau khi lấy doanh thu trừ đi chi phí
+ inventory_items.product_category: Phân loại sản phẩm (Quần Jeans, Áo len, Áo khoác,...)
+ inventory_items.product_name: Tên chi tiết của sản phẩm đó
+ inventory_items.product_department: Loại sản phẩm dành cho ai (Nam, nữ)
+ created_at: Ngày tạo đơn hàng (Có thể tạo được sau khi ship đơn hàng và người đặt hàng đã nhận được đơn hàng)
+ shipped_at: Ngày giao hàng từ kho
+ delivered_at: Ngày người đặt hàng nhận được đơn hàng
+ returned_at: Ngày người đặt hàng trả lại đơn hàng
+ total_return: Tổng doanh thu từ các đơn hàng có trạng thái hoàn đơn, hủy đơn (Return, Cancel)
+ DATE_DIFF(order_items.delivered_at , order_items.shipped_at, DAY) as delivery_time_in_days: Khoảng cách ngày từ lúc hàng ra khỏi kho đến lúc người đặt hàng nhận được đơn hàng
+ DATE_DIFF(order_items.shipped_at , order_items.created_at, DAY) as process_time_in_days: Khoảng cách ngày từ lúc xử lý đơn hàng trên hệ thống đến lúc đơn hàng ra khỏi kho
+ DATE_DIFF(order_items.returned_at , order_items.created_at, DAY) as return_after_received_days: Khoảng cách ngày từ lúc xử lý đơn hàng trên hệ thống đến lúc đơn hàng được trả lại 

FROM big-query-378507.thelook_ecommerce.order_items - Bảng gốc được dùng: Order Item
  LEFT JOIN big-query-378507.thelook_ecommerce.users - Bảng dùng để join đầu tiên lấy thông tin nhân khẩu học: Users
  ON users.id = order_items.user_id

  RIGHT JOIN big-query-378507.thelook_ecommerce.inventory_items - Bảng dùng để join lần 2 lấy thông tin về sản phẩm - Inventory Items 
  ON inventory_items.product_id = order_items.product_id 

  RIGHT JOIN big-query-378507.thelook_ecommerce.orders - Bảng dùng để join lần 3 lấy thông tin về đơn hàng - Orders 
  ON orders.order_id = order_items.order_id 
ORDER BY order_items.created_at DESC - Sắp xếp thứ tự theo ngày tạo đơn hàng để theo dõi theo ngày mới 
