# MarketPlaceSpringBoot2025
Buyer and Seller app that is better than Thumbtack - Spring Boot backend and Flutter frontend

Screenshots of the frontend are shown first, then some code screenshots after.

Note 1: Update the application.properties file with your own values if you want to run the application.

Note 2: The security/EmailService.java file on line 20 is calling the message.setFrom() method, and it currently has "your_email_address_here" as the String value being passed in as an argument, please replace with a proper email address.

Note 3: Run the frontend on port 53660 or change intances where port 5366 for the frontend is mentioned, it's only in security/EmaliService.java at line 16 in the sendPasswordResetEmail() method and in security/SecurityConfig.java at line 57 in the corsConfigurationSource() method.

![image](https://github.com/user-attachments/assets/8f51e8af-03f6-40fc-883d-4a6fba6cb4ed)

![image](https://github.com/user-attachments/assets/6eba0d38-9b26-44c5-9f25-008872e4a553)

![image](https://github.com/user-attachments/assets/251a6633-9547-42f5-b21c-98fd5a9ea5e5)

![image](https://github.com/user-attachments/assets/90b71b89-605e-4865-9988-c6f250f408cb)
