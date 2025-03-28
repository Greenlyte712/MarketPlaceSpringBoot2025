import 'dart:convert';
import 'package:http/http.dart' as http;

class ConversationService {
  final String token;

  ConversationService(this.token);

  // Modified fetchConversations to accept the endpoint as a parameter
  Future<List<dynamic>> fetchConversations(String endpoint) async {
    final String url = 'http://localhost:8082/api/conversations/$endpoint';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load conversations: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching conversations: $e');
    }
  }

  Future<void> sendMessage(int conversationId, String messageContent) async {
    final url = Uri.parse('http://localhost:8082/api/conversations/$conversationId/message');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'messageContent': messageContent},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send message: ${response.statusCode}');
    }
  }

  Future<bool> initiateConversation(int sellerId, String message, Map<int, String> answers, String token) async {
    final String url = 'http://localhost:8082/api/conversations/initiate';

    // Mapping the answers into the format the API expects
    List<Map<String, dynamic>> leadQuestionAnswers = answers.entries.map((entry) => {'questionId': entry.key, 'answer': entry.value}).toList();

    final body = jsonEncode({
      'sellerId': sellerId,
      'messageContent': message,
      'leadQuestionAnswers': leadQuestionAnswers,
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to initiate conversation.');
      }
    } catch (e) {
      throw Exception('Error initiating conversation: $e');
    }
  }

  Future<void> deleteConversationById(int conversationId) async {
    final String url = 'http://localhost:8082/api/conversations/delete-conversation-by-id/$conversationId'; // The endpoint URL

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include token for authentication
        },
      );

      if (response.statusCode == 204) {
        print("Conversation deleted successfully");
        // Optionally, handle any success logic here
      } else {
        // Handle server errors or failure cases
        throw Exception('Failed to delete conversation. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      // Handle errors like network issues
      throw Exception('Error occurred while deleting conversation: $e');
    }
  }
}
