import 'package:flutter/material.dart';

import 'package:find_a_pro_pronto_app/services/conversation_service.dart';
import 'package:find_a_pro_pronto_app/services/fetch_sellers_service.dart';
import 'package:find_a_pro_pronto_app/services/get_lead_questions_to_init_convo.dart';

import 'package:find_a_pro_pronto_app/widgets/lead_questions_dialog.dart';

class SellerProviderForBuyer extends ChangeNotifier {
  final FetchSellerService fetchSellerService;
  final GetLeadQuestionsToInitiateConversationService leadQuestionsService;
  final ConversationService conversationService;
  final String token;

  List<dynamic> sellers = [];

  bool isLoading = true;
  String? errorMessage;

  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController keywordController = TextEditingController();

  SellerProviderForBuyer({
    required this.fetchSellerService,
    required this.leadQuestionsService,
    required this.conversationService,
    required this.token,
  }) {
    fetchSellers();
  }

  Future<void> fetchSellers() async {
    // Start loading
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    String zipCode = zipCodeController.text.trim();
    String tag = keywordController.text.trim();

    try {
      // Call the service method to fetch sellers by zip code and tag
      List<dynamic> fetchedSellers =
          await fetchSellerService.fetchSellersByZipAndTag(zipCode, tag, token);

      // Update the sellers list with the fetched sellers
      sellers = fetchedSellers;
    } catch (e) {
      // If there is an error, store the error message
      errorMessage = 'Error fetching sellers: $e';
    } finally {
      // Stop loading
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getLeadQuestions(int sellerId, BuildContext context) async {
    try {
      List<dynamic> questions =
          await leadQuestionsService.getLeadQuestions(sellerId, token);
      showLeadQuestionsDialog(context, sellerId, questions);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  void showLeadQuestionsDialog(
      BuildContext context, int sellerId, List<dynamic> questions) {
    showDialog(
      context: context,
      builder: (context) {
        return LeadQuestionsDialog(
          questions: questions,
          onSend: (answers, message) {
            initiateConversation(context, sellerId, message, answers);
          },
        );
      },
    );
  }

  Future<void> initiateConversation(BuildContext context, int sellerId,
      String message, Map<int, String> answers) async {
    try {
      bool success = await conversationService.initiateConversation(
        sellerId,
        message,
        answers,
        token,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? "Conversation initiated successfully!"
              : "Failed to initiate conversation."),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }
}
