import 'package:find_a_pro_pronto_app/utils/date_time_helper.dart';
import 'package:flutter/material.dart';

class MessageDialog extends StatelessWidget {
  final dynamic conversation;
  final List<dynamic> messages;
  final TextEditingController messageController;
  final Function(String) onSendMessage;

  const MessageDialog({
    required this.conversation,
    required this.messages,
    required this.messageController,
    required this.onSendMessage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 800, // Adjust width as needed
        height: 800, // Adjust height as needed
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Conversation Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (messages
                .isNotEmpty) // Only show timestamp if there are messages
              Text(
                'Started on: ${DateTimeHelper.formatTimestamp(messages.last['timestamp'])}',
                style: TextStyle(
                    fontSize: 14, color: const Color.fromARGB(255, 54, 52, 52)),
              ),
            Divider(),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true, // Keeps scrollbar always visible
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Timestamp: ${DateTimeHelper.formatTimestamp(msg['timestamp'])}',
                          style: TextStyle(
                              fontSize: 12,
                              color: const Color.fromARGB(255, 54, 52, 52)),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    '${msg['senderType'] == "buyer" ? conversation['buyer']['name'] : conversation['seller']['companyName']}: ',
                                style: TextStyle(
                                  color: msg['senderType'] == "buyer"
                                      ? Colors.black87
                                      : const Color.fromARGB(255, 9, 2, 102),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ...msg['content']
                                  .split(
                                      '<^^^>') // Split the content at "<^^^>"
                                  .map<InlineSpan>((line) => TextSpan(
                                        text: line.trim() +
                                            '\n', // Add a newline after each split part
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: msg['senderType'] == "buyer"
                                              ? Colors.black87
                                              : const Color.fromARGB(
                                                  255, 9, 2, 102),
                                        ),
                                      ))
                                  .toList(),
                            ],
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      onSendMessage(messageController.text);
                      messageController.clear();
                    },
                    child: Text('Send'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
