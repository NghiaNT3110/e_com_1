# Here're notes about queried fields (Data schema after transformation): 

+ inventory_item_id: Product ID of the item in storage.
  
+ order_id: Order ID
  
+ full_name: Full name of the user
  
+ email: Email of the user

+ age: Age of the user

+ city: The city where the user lives and receives orders.

+ state: The state where the user lives and receives orders.

+ country: The country where the user lives and  orders.

+ status: Status of the order (Processing, Shipped, Deliveried, Cancelled, Returned)

+ traffic_source: Traffic Source where the user purchase products (Email, Facebook Ads, Google Ads, Organic)

+ sale_price: Sale price of the product on the Market
  
+ inventory_items.cost: Original Price or Buying Cost of the product

+ num_of_item: Number of the item that the user purchase in the order

+ total_product_cost: Total cost = inventory_items.cost * orders.num_of_item 

+ total_revenue_purchase: Total Revenue = orders.num_of_item * sale_price

+ profit: Total Profit = orders.num_of_item * (sale_price - inventory_items.cost)

+ inventory_items.product_category: Product Category (Jeans, Sweater, Coats,...)
  
+ inventory_items.product_name: Detailed name of the product
  
+ inventory_items.product_department: Gender of the product that user purchase
  
+ created_at: Order created date (Can be created even after the order being shipped or received/returned)
  
+ shipped_at: The day when the order shipped from the storage
  
+ delivered_at: The day when the user receive the order
  
+ returned_at: The day when the user return the order
  
+ total_return: Total Revenue from orders with the status "Return" or "Cancel"
  
+ delivery_time_in_days: Delivery time from leaving the warehouse = DATE_DIFF(order_items.delivered_at , order_items.shipped_at, DAY) 
  
+ process_time_in_days: Processing time from order creation to shipment = DATE_DIFF(order_items.shipped_at , order_items.created_at, DAY)
  
+ return_after_received_days: Time to return the order after receiving = DATE_DIFF(order_items.returned_at , order_items.created_at, DAY)
