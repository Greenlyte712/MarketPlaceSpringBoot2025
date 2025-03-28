// widgets/lead_questions_dialog.dart
import 'package:flutter/material.dart';

class LeadQuestionsDialog extends StatelessWidget {
  final List<dynamic> questions;
  final Function(Map<int, String> answers, String message) onSend;

  const LeadQuestionsDialog({
    required this.questions,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();
    Map<int, TextEditingController> answerControllers = {};

    for (var question in questions) {
      answerControllers[question['id']] = TextEditingController();
    }

    return AlertDialog(
      title: Text("Initiate Conversation"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text("Enter your message:"),
            TextField(controller: messageController),
            const SizedBox(height: 10),
            Text(
                "The vendor would like you to answer these questions so that they can better help you:"),
            const SizedBox(height: 10),
            ...questions.map((q) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(q['question'],
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(controller: answerControllers[q['id']]),
                  const SizedBox(height: 10),
                ],
              );
            }).toList(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            Map<int, String> answers = answerControllers
                .map((id, controller) => MapEntry(id, controller.text));

            onSend(answers, messageController.text);
            Navigator.pop(context);
          },
          child: Text("Send"),
        ),
      ],
    );
  }
}
