import 'dart:convert';
import 'package:http/http.dart' as http;

class GetLeadQuestionsToInitiateConversationService {
  Future<List<dynamic>> getLeadQuestions(int sellerId, String token) async {
    final String url =
        'http://localhost:8082/api/conversations/get_lead_questions_from_seller?sellerId=$sellerId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch lead questions.');
      }
    } catch (e) {
      throw Exception('Error fetching lead questions: $e');
    }
  }
}
