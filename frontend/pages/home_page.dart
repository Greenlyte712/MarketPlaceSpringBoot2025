import 'package:flutter/material.dart';
import '../widgets/home_page_button.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Find a Pro Pronto"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.start, // Align the items at the top
          crossAxisAlignment:
              CrossAxisAlignment.center, // Center the items horizontally
          children: [
            // Add a Text widget below the AppBar
            Padding(
              padding: const EdgeInsets.only(
                  top: 20.0), // Optional padding for spacing
              child: Text(
                "Welcome to Find a Pro Pronto! Where Pros don't get ripped off!", // The text you want to show below the AppBar
                style: TextStyle(
                  fontSize: 24, // Customize the font size
                  fontWeight: FontWeight.bold, // Optional: make it bold
                ),
              ),
            ),
            SizedBox(
                height: 30), // Add some space between the text and the buttons
            HomePageButton(
              text: "Register as Seller",
              route: '/create-seller',
            ),
            SizedBox(height: 20),
            HomePageButton(
              text: "Login",
              route: '/login',
            ),
            SizedBox(height: 20),
            HomePageButton(
              text: "Register as Buyer",
              route: '/create-buyer',
            ),
            SizedBox(height: 20),
            HomePageButton(
              text: "Reset Password",
              route: '/reset-password',
            ),
          ],
        ),
      ),
    );
  }
}
