import 'package:flutter/material.dart';

import '../services/storage_service.dart';
import 'seller_create_lead_questions_page.dart';
import 'seller_see_their_own_lead_questions_page.dart';
import 'seller_view_their_details_page.dart';
import 'seller_see_their_conversations_page.dart';

class SellerDashboardPage extends StatelessWidget {
  final StorageService jwtService = StorageService();

  SellerDashboardPage({super.key});

  Future<void> _navigateWithToken(
      BuildContext context, Widget Function(String) pageBuilder) async {
    String? token = await jwtService.getToken();

    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unauthorized: Please log in")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => pageBuilder(token)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seller Dashboard"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to your Seller Dashboard!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: const Text("Log Out"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateWithToken(context,
                  (token) => SellerCreateLeadQuestionsPage(token: token)),
              child: const Text("Create Lead Questions"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateWithToken(context,
                  (token) => SellerSeeTheirOwnLeadQuestionsPage(token: token)),
              child: const Text("View Lead Questions"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateWithToken(
                  context, (token) => SellerViewDetailsPage(token: token)),
              child: const Text("View Seller Details"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateWithToken(context,
                  (token) => SellerSeeTheirConversationsPage(token: token)),
              child: const Text("View Conversations"),
            ),
          ],
        ),
      ),
    );
  }
}
