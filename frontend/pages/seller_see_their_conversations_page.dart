// ignore: unused_import
import 'package:find_a_pro_pronto_app/services/conversation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/conversation_provider_for_seller.dart';
import '../widgets/conversation_list_item.dart';

class SellerSeeTheirConversationsPage extends StatelessWidget {
  final String token;

  const SellerSeeTheirConversationsPage({required this.token, super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConversationProviderForSeller(token)..fetchConversations(),
      child: Scaffold(
        appBar: AppBar(title: Text('Conversations')),
        body: Consumer<ConversationProviderForSeller>(
          builder: (context, conversationProvider, child) {
            if (conversationProvider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (conversationProvider.errorMessage != null) {
              return Center(child: Text('Error: ${conversationProvider.errorMessage}'));
            }
            if (conversationProvider.conversations.isEmpty) {
              return Center(child: Text('You have no messages'));
            }
            return ListView.builder(
              itemCount: conversationProvider.conversations.length,
              itemBuilder: (context, index) {
                return ConversationListItem(
                  conversation: conversationProvider.conversations[index],
                  onSendMessage: (conversationId, messageContent) => conversationProvider.sendMessage(conversationId, messageContent),
                  token: token,
                  onDelete: conversationProvider.deleteConversation,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
