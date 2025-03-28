// widgets/seller_card.dart

import 'package:find_a_pro_pronto_app/pages/buyer_conversations_page.dart';
import 'package:flutter/material.dart';

class SellerCard extends StatelessWidget {
  final String companyName;
  final String phoneNumber;
  final String email;
  final String address;
  final dynamic companyDescription;
  final dynamic webAddress;
  final dynamic metaTags;
  final int sellerId;
  final VoidCallback onMessagePressed;
  final String token;

  final dynamic servicedZipCodes;

  const SellerCard(
      {required this.companyName,
      required this.phoneNumber,
      required this.email,
      required this.address,
      required this.companyDescription,
      required this.webAddress,
      required this.metaTags,
      required this.servicedZipCodes,
      required this.sellerId,
      required this.onMessagePressed,
      required this.token});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              companyName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInfoRow("Phone:", phoneNumber),
            _buildInfoRow("Email:", email),
            _buildInfoRow("Address:", address),
            _buildInfoRow("What we do:", companyDescription),
            _buildInfoRow("Our website:", webAddress),
            _buildInfoRow("Tags:", metaTags),
            _buildInfoRow("Serviced Zip Codes:", servicedZipCodes),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align buttons to the left
                children: [
                  ElevatedButton(
                    onPressed: onMessagePressed,
                    child: const Text("Start New Conversation"),
                  ),
                  const SizedBox(height: 8), // Add some space between the buttons
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the filtered conversations page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BuyerConversationsPage(
                            sellerId: sellerId, // Pass sellerId here
                          ),
                        ),
                      );
                    },
                    child: const Text("View Existing Conversations"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14, color: Colors.black),
          children: [
            TextSpan(
              text: "$title ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value.toString()),
          ],
        ),
      ),
    );
  }
}
