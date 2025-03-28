import 'package:find_a_pro_pronto_app/services/storage_service.dart';
import 'package:flutter/material.dart';
import '../services/conversation_service.dart';

class ConversationProviderForBuyer extends ChangeNotifier {
  ConversationService? _conversationService;
  final StorageService _storageService = StorageService();
  List<dynamic> _conversations = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<dynamic> get conversations => _conversations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ConversationProviderForBuyer() {
    _initializeService();
  }

  Future<void> _initializeService() async {
    String? token = await _storageService.getToken();
    if (token != null) {
      _conversationService = ConversationService(token);
      await fetchConversations();
    } else {
      _isLoading = false;
      _errorMessage = "User not authenticated.";
      notifyListeners();
    }
  }

  Future<void> fetchConversations({int? sellerId}) async {
    if (_conversationService == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final fetchedConversations = await _conversationService!.fetchConversations("get-all-conversations-for-buyer");

      _conversations =
          sellerId == null ? fetchedConversations : fetchedConversations.where((conversation) => conversation['seller']['id'] == sellerId).toList();

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(int conversationId, String messageContent, BuildContext context) async {
    if (_conversationService == null) return;

    try {
      await _conversationService!.sendMessage(conversationId, messageContent);
      await fetchConversations(); // Refresh conversations after sending a message
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to send message: $e");
    }
  }

  Future<void> deleteConversation(int conversationId) async {
    if (_conversationService == null) return;

    try {
      await _conversationService!.deleteConversationById(conversationId);
      _conversations.removeWhere((conversation) => conversation['id'] == conversationId);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to delete conversation: $e");
    }
  }
}
