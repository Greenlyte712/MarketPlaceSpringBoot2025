import 'dart:convert';
import 'package:http/http.dart' as http;

class FetchSellerService {
  Future<List<dynamic>> fetchSellersByZipAndTag(
      String zipCode, String tag, String token) async {
    final String url =
        'http://localhost:8082/buyer/sellersByZipAndTag?zipCode=$zipCode&tag=$tag';

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
        throw Exception(
            'Failed to load sellers by zip code and tag: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching sellers by zip code and tag: $e');
    }
  }
}
