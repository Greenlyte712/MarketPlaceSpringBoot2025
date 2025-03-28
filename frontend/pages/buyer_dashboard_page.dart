import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'buyer_conversations_page.dart';
import 'buyer_see_all_sellers_page.dart';

class BuyerDashboardPage extends StatelessWidget {
  final StorageService jwtService = StorageService();

  BuyerDashboardPage({super.key});

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
        title: const Text("Buyer Dashboard"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to your Buyer Dashboard!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateWithToken(
                  context, (token) => GetAllSellersPage(token: token)),
              child: const Text("View Sellers"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateWithToken(
                  context, (token) => BuyerConversationsPage()),
              child: const Text("View Conversations with Sellers"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: const Text("Log Out"),
            ),
          ],
        ),
      ),
    );
  }
}
