// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SellerSeeTheirOwnLeadQuestionsPage extends StatefulWidget {
  final String token;

  const SellerSeeTheirOwnLeadQuestionsPage({required this.token});

  @override
  _SellerSeeTheirOwnLeadQuestionsPageState createState() =>
      _SellerSeeTheirOwnLeadQuestionsPageState();
}

class _SellerSeeTheirOwnLeadQuestionsPageState
    extends State<SellerSeeTheirOwnLeadQuestionsPage> {
  List<Map<String, dynamic>> questions = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    const String url = 'http://localhost:8082/seller/get-lead-questions';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          questions = data.map((item) {
            return {
              'id': item['id'], // Store ID
              'question': item['question'],
            };
          }).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              'Failed to load questions. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error occurred: $e';
        isLoading = false;
      });
    }
  }

  Future<void> deleteQuestion(int id) async {
    final String url =
        'http://localhost:8082/seller/delete-lead-question-by-id/$id'; // Use the endpoint

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          questions.removeWhere((question) => question['id'] == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Question deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to delete question. Status: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting question: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lead Questions'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                )
              : ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    final question = questions[index];
                    return ListTile(
                      leading: Icon(Icons.question_mark),
                      title: Text(question['question']),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteQuestion(question['id']),
                      ),
                    );
                  },
                ),
    );
  }
}
