import 'package:find_a_pro_pronto_app/providers/seller_provider_for_buyer.dart';
import 'package:find_a_pro_pronto_app/services/conversation_service.dart';
import 'package:find_a_pro_pronto_app/services/fetch_sellers_service.dart';
import 'package:find_a_pro_pronto_app/services/get_lead_questions_to_init_convo.dart';
import 'package:find_a_pro_pronto_app/widgets/loading_indicator.dart';
import 'package:find_a_pro_pronto_app/widgets/seller_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GetAllSellersPage extends StatelessWidget {
  final String token;

  const GetAllSellersPage({required this.token});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final provider = SellerProviderForBuyer(
          fetchSellerService: FetchSellerService(),
          leadQuestionsService: GetLeadQuestionsToInitiateConversationService(),
          conversationService: ConversationService(token),
          token: token,
        );
        provider.fetchSellers(); // Call fetchSellers immediately
        return provider;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("All Sellers")),
        body: Consumer<SellerProviderForBuyer>(
          builder: (context, provider, child) {
            return Column(
              children: [
                // Zip Code Filter Input
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: provider.zipCodeController,
                          decoration: const InputDecoration(
                            labelText: "Enter ZIP Code to filter...",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          provider.zipCodeController.clear();
                          provider.fetchSellers(); // Clear and fetch again
                        },
                        child: const Text("Clear"),
                      ),
                    ],
                  ),
                ),
                // Keyword Filter Input (Meta Tags)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: provider.keywordController,
                          decoration: const InputDecoration(
                            labelText: "Enter keyword to filter...",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          provider.keywordController.clear();
                          provider.fetchSellers(); // Clear and fetch again
                        },
                        child: const Text("Clear"),
                      ),
                    ],
                  ),
                ),
                // Apply Filter Button
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      provider
                          .fetchSellers(); // Trigger fetch with current filters
                    },
                    child: const Text("Apply Filter"),
                  ),
                ),
                // Seller List
                Expanded(
                  child: provider.isLoading
                      ? const LoadingIndicator()
                      : provider.errorMessage != null
                          ? Center(child: Text(provider.errorMessage!))
                          : provider.sellers.isEmpty
                              ? Center(
                                  child: Text(
                                      "No vendors found that match your zip code and keywords. Or your left either field blank."))
                              : ListView.builder(
                                  itemCount: provider.sellers.length,
                                  itemBuilder: (context, index) {
                                    final seller = provider.sellers[index];
                                    return SellerCard(
                                      token: provider.token,
                                      sellerId: seller["id"],
                                      companyName: seller['companyName'],
                                      phoneNumber: seller['phoneNumber'],
                                      email: seller['email'],
                                      address:
                                          "${seller['sellerAddress']['street']}, ${seller['sellerAddress']['city']}, ${seller['sellerAddress']['state']} ${seller['sellerAddress']['zipcode']}",
                                      companyDescription:
                                          seller["companyDescription"],
                                      webAddress: seller["webAddress"],
                                      metaTags: seller["metaTags"],
                                      servicedZipCodes:
                                          seller["servicedZipCodes"],
                                      onMessagePressed: () =>
                                          provider.getLeadQuestions(
                                              seller['id'], context),
                                    );
                                  },
                                ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
