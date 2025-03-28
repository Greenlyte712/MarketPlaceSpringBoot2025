import 'package:find_a_pro_pronto_app/services/conversation_service.dart';
import 'package:find_a_pro_pronto_app/utils/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'message_dialog.dart';

class ConversationListItem extends StatelessWidget {
  final dynamic conversation;
  final Function(int, String) onSendMessage;
  final String token;
  final Function(int) onDelete; // Callback function for deletion

  const ConversationListItem({
    required this.conversation,
    required this.onSendMessage,
    super.key,
    required this.token,
    required this.onDelete,
  });
// Method to delete the conversation
  Future<void> _deleteConversation(BuildContext context, int conversationId) async {
    final conversationService = ConversationService(token);

    try {
      await conversationService.deleteConversationById(conversationId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conversation deleted successfully')),
      );
      onDelete(conversationId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting conversation: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final seller = conversation['seller'];
    final buyer = conversation['buyer'];
    final messages = conversation['messages'];

    final lastMessage = messages.isNotEmpty
        ? messages.first['content'].contains('<^^^>')
            ? 'Conversation initiated'
            : messages.first['content']
        : 'No messages';

    final lastMessageTimeStamp = messages.isNotEmpty ? DateTimeHelper.formatTimestamp(messages.first['timestamp']) : 'No messages';

    final conversationStart = messages.isNotEmpty ? DateTimeHelper.formatTimestamp(messages.last['timestamp']) : 'Unknown';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: const Color.fromARGB(255, 3, 1, 78),
          child: Text(
            seller['companyName'][0], // First letter of company name
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        title: Text(
          '${seller['companyName']} & ${buyer['name']} Started on: $conversationStart',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last message: $lastMessage',
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(
              'Sent on: $lastMessageTimeStamp',
              style: const TextStyle(fontSize: 12, color: Color.fromARGB(255, 3, 1, 78)),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _deleteConversation(context, conversation['id']); // Delete conversation
              },
            ),
          ],
        ),
        onTap: () {
          TextEditingController messageController = TextEditingController();
          showDialog(
            context: context,
            builder: (context) {
              return MessageDialog(
                conversation: conversation,
                messages: messages,
                messageController: messageController,
                onSendMessage: (message) {
                  onSendMessage(conversation['id'], message);
                  // Close the message dialog after sending the message
                  Navigator.pop(context);
                  // Show the custom dialog after the message is sent
                  showDialog(
                    context: context,
                    barrierDismissible: false, // Prevent dismissing the dialog by tapping outside
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Message Sent!'),
                        content: Text('Your message has been successfully sent.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
