import 'package:flutter/material.dart';

import '../services/create_lead_questions_service.dart';
import '../widgets/create_lead_questions_form.dart';

class SellerCreateLeadQuestionsPage extends StatefulWidget {
  final String token;

  const SellerCreateLeadQuestionsPage({super.key, required this.token});

  @override
  _SellerLeadQuestionsPageState createState() =>
      _SellerLeadQuestionsPageState();
}

class _SellerLeadQuestionsPageState
    extends State<SellerCreateLeadQuestionsPage> {
  final TextEditingController _questionController = TextEditingController();
  bool _isLoading = false;
  String _message = '';

  late final CreateLeadQuestionsService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = CreateLeadQuestionsService(
        widget.token); // Set the token after the widget is created
  }

  Future<void> _submitQuestion(String question) async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    final responseMessage = await _apiService.submitLeadQuestion(question);

    setState(() {
      _message = responseMessage;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Lead Questions')),
      body: CreateLeadQuestionsForm(
        questionController: _questionController,
        isLoading: _isLoading,
        message: _message,
        onSubmit: _submitQuestion,
      ),
    );
  }
}
