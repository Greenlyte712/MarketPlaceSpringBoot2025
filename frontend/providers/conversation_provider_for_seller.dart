import 'package:flutter/material.dart';
import '../services/conversation_service.dart';

class ConversationProviderForSeller extends ChangeNotifier {
  final ConversationService _conversationService;
  List<dynamic> _conversations = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<dynamic> get conversations => _conversations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ConversationProviderForSeller(String token)
      : _conversationService = ConversationService(token);

  Future<void> fetchConversations() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _conversations = await _conversationService
          .fetchConversations("get-all-conversations-for-seller");
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(int conversationId, String messageContent) async {
    try {
      await _conversationService.sendMessage(conversationId, messageContent);
      fetchConversations(); // Refresh the list after sending a message
    } catch (e) {
      print("Failed to send message: $e");
    }
  }

  void deleteConversation(int conversationId) {
    _conversations
        .removeWhere((conversation) => conversation['id'] == conversationId);
    notifyListeners();
  }
}
