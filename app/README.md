# ISC
- The ISC Slot Booking Application is an mobile application created to tackle the problems which exists with the current manual
  slot booking system. 
- It aims to ease up processes for all parties involved in the booking of slots for the gym and for other indoor sports as well. 

# Workflow
- User first registers themselves through their SNU ID and then signups.
- Then they select their respective sports , the day that they want , the slot timings and at the end enter their name and SNU id.
- On top of that they can invite other students to play with them for the very same .
- Students on receiving such invitations will have an option to either accept or decline the invitation and depending on that their names get added to the booking ticket.
- Those ids which have the admin access can disable the sports either sport wise, day wise or slot wise .
- After choosing the a particular they can mark the attendance using a QR code scanner and scan the QR code which is generated on the client side.


# Installing the app
- For running the app kindly download the .apk file on your android phone, install and signup as a user from your 'SNU ID'.
- For accessing the admin side kindly use the following credentials.
'tusharmishra16@gmail.com' as email and 'password' as password.

# Frontend
The frontend has been created using Flutter.
Frontend code is in 'lib' folder:
- assets folder the app icon and some images.
- routes file contains the routes to different screens of the app
- components folder lies various widgets that are used by different screens of the app
- screens folder contains different screens of the app such as event page, authentication page,notification page,booking page , admin page etc.
- 'constants' file contais the error handling logic, and global variables.
- status file contains the enums used to check the booking status
- test file contains the unit testing file
- user info file contains the logic for checking the user info such as whether he is an admin or not, which sport they are booking for etc.
- provider folder contains state management code used throughout the app.
- main file contains the driver code for the app.


# Backend
- The backend has been created using Python(Flask framework) and Node.JS(Express.JS framework). Flask has been used to handle the operations between the user and the database.
- Express.JS has been used for user authentication along with Firebase which has been used to manage the users and to maintain the user privacy.
- There is 'server' folder that contains two sub-folders 'python' and 'js' each having the respective code for the backend.
- The user operations are managed by 'main_user.py'.
- The seller operations are managed by 'main_seller.py'
- The required packaged can be installed using the requirements.txt file and package.json

# Database
We have used MySQL as our database engine. There 9 tables in our database:
    1) Orders - This table records all the orders placed by the user with order no as the primary key.
    2) Products_in_order - This table records all the products in a specific order with the order no and sku as composite primary key.
    3) Products - This table records all the products that are listed on the platform with sku as the primary key.
    4) Keywords - This table records all the keywords of a specific product to make search easier with keywork and sku as primary key.
    5) Categories - This table records all the categories that are available on the platform with category id as the primary key.
    6) Users - This table maintains the records of the users with username as the primary key.
    7) Cart - This table maintains the users cart with the username and sku as the primary key.
    8) Seller - This table records the sellers that are registered on the platform.
    9) Reviews - This table maintains the review given by each user for a specific product.




