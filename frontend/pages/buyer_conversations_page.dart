import 'package:find_a_pro_pronto_app/providers/conversation_provider_for_buyer.dart';
// ignore: unused_import
import 'package:find_a_pro_pronto_app/services/conversation_service.dart';
import 'package:find_a_pro_pronto_app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/conversation_list_item.dart';

class BuyerConversationsPage extends StatelessWidget {
  final int? sellerId;

  BuyerConversationsPage({this.sellerId, super.key});

  final StorageService storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ConversationProviderForBuyer>(
      create: (_) => ConversationProviderForBuyer(),
      child: Scaffold(
        appBar: AppBar(title: Text('Conversations')),
        body: Consumer<ConversationProviderForBuyer>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (provider.errorMessage != null) {
              return Center(child: Text(provider.errorMessage!));
            }

            final conversations = sellerId == null
                ? provider.conversations
                : provider.conversations.where((conversation) => conversation['seller']['id'] == sellerId).toList();

            if (conversations.isEmpty) {
              return Center(child: Text('You have no messages'));
            }

            return FutureBuilder<String?>(
              future: storageService.getToken(), // Get the token asynchronously
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator()); // Show loading while fetching the token
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(child: Text('Failed to load token')); // Handle errors
                }

                final token = snapshot.data!; // Extract the token

                return ListView.builder(
                  itemCount: conversations.length,
                  itemBuilder: (context, index) {
                    return ConversationListItem(
                      conversation: conversations[index],
                      onSendMessage: (conversationId, messageContent) {
                        provider.sendMessage(conversationId, messageContent, context);
                      },
                      token: token, // Use the fetched token
                      onDelete: (conversationId) {
                        provider.deleteConversation(conversationId);
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
