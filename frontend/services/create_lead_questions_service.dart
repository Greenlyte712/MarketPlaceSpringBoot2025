import 'dart:convert';
import 'package:http/http.dart' as http;

class CreateLeadQuestionsService {
  final String token;

  CreateLeadQuestionsService(this.token);

  Future<String> submitLeadQuestion(String question) async {
    const String baseUrl = 'http://localhost:8082';
    final String createLeadQuestionsUrl =
        '$baseUrl/seller/create-lead-questions';

    final Map<String, String> headers = {
      'accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final Map<String, String> data = {
      'question': question,
    };

    try {
      final response = await http.post(
        Uri.parse(createLeadQuestionsUrl),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return 'Question submitted successfully!';
      } else {
        return 'Submission failed: ${response.statusCode}';
      }
    } catch (error) {
      return 'An error occurred: $error';
    }
  }
}
