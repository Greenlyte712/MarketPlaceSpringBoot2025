import 'package:flutter/material.dart';

class CreateLeadQuestionsForm extends StatelessWidget {
  final TextEditingController questionController;
  final bool isLoading;
  final String message;
  final Function(String) onSubmit;

  const CreateLeadQuestionsForm({
    Key? key,
    required this.questionController,
    required this.isLoading,
    required this.message,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: questionController,
            decoration: InputDecoration(
              labelText: 'Enter your lead question',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16.0),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: () {
                    final question = questionController.text.trim();
                    if (question.isNotEmpty) {
                      onSubmit(question);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Question cannot be empty!')),
                      );
                    }
                  },
                  child: Text('Submit Question'),
                ),
          SizedBox(height: 16.0),
          Text(
            message,
            style: TextStyle(
              color: message.contains('success') ? Colors.green : Colors.red,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
