Website creation instructions/feature manual.

Create a restaurant POS(point of sale) system where customer can order his meal and pick up his order at scheduled time.

Users:

-Our site would have two types of users, Customers & Restaurant admin. 
-Customer can signup by providing his valid details 
-Name, email, password
-On signup, user will receive a verification email like other sites do
-Forgot password and remember me functionality
-Only verified user can access the system
-Admin can be created by a rake task “rake admin:new”, this rake task will prompt user to enter required details from console.
-When admin is created no verification email is required. His account is verified by default. 


Restaurant Admin Section:

-Only admin users can access the admin section from the /admin namespace
-A restaurant can have multiple locations. So admin should be able to manage multiple locations for his restaurant.
-Out of these locations a location can be marked as default location. 
-Location would have opening and closing time
-Admin manage ingredients a list of ingredients
-Ingredient would have name and price per portion, veg/non-veg. There should be an option to mark an ingredient as “Can be requested extra?”
-Like some customer may like to add extra cheese slice to their meal. 
-Admin should be able to manage ingredient’s inventory location wise. 
-Admin should have option to add/reduce qty with a comment.


Admin manage meals:

-Meal can be created by giving a name, and choosing ingredients and their portions. For example a “Cheesy Veg Burger” can have 1 Wheat bun, 2 cheese slices, 1 veg patty. Meal’s price is calculated based on the ingredients and qty.
-Meal can also have an image.
-Admin can update activate/deactivate meals. Meals are global, like if it is active then it is active for listing on all locations, 
-Meal’s availability on a particular location will depends on the available inventory of its ingredients at the location.


Browsing and ordering meals

Customer, will see all the available meals from the customer’s selected location. 
First time visitor will see the restaurant’s default location
Customer will see a dropdown of all locations at the top of the page, which he can use to change location. Next time onwards this will be used as selected location for the customer. 
Available meals: Meals’ whose ingredients in sufficient qty are available at the location to prepare at least one qty of the meal 
Filter meals by veg/nonveg
Customer can add Meals to his cart. Max meal qty will be based on available ingredient qty. So if according to inventory, only 3 burgers can be prepared, customer can not add more than 3 burgers.
If a customer left his page open, and a meal is sold out then it should disappear from his screen vise versa. Make use of ajax polling.
Customer can checkout and choosing a pick time between the location’s operating hours and providing his mobile number. Customer should receive an order confirmation email
For payment use stripe checkout
As soon as an order is placed, system should block ingredients qty. Also should mark related meals sold out if needed. 
Customer can see his orders from myorders section. 
Customer can cancel his order anytime before 30 mins of pickup time, after that he can not. Order cancellation will affect inventory and hence meal’s availability.


Location POS page

-Admin should have access to location pos page(“http://localhost/pos/patel-nagar”), where all the orders due will be listed by the pickup time
-Admin should be able to mark order as ready and then picked up
-New orders should appear without page refresh.


Additional:

-Reviews and Rating for Meals


Repots:

-Popular meals
-Popular meal for the day
-Low inventory predictions (not completed)
etc..
