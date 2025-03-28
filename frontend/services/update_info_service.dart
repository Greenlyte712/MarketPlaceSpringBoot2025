import 'dart:convert';

import 'package:http/http.dart' as http;

class UpdateInfoService {
  final String token;

  UpdateInfoService(this.token);

  Future<void> updateCompanyDescription(String newDescription) async {
    const String url =
        'http://localhost:8082/seller/seller-update-their-company-description';

    try {
      final response = await http.post(
        Uri.parse(
            '$url?companyDescription=${Uri.encodeComponent(newDescription)}'),
        headers: {
          'Authorization': 'Bearer $token',
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200) {
        print('Company Description updated successfully!');
      } else {
        print('Failed to update. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating company description: $e');
    }
  }

  Future<void> updateWebAddress(String newWebAddress) async {
    const String url =
        'http://localhost:8082/seller/seller-update-their-web-address';

    try {
      final response = await http.post(
        Uri.parse('$url?webAddress=${Uri.encodeComponent(newWebAddress)}'),
        headers: {
          'Authorization': 'Bearer $token',
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200) {
        print('web address updated successfully!');
        print('----------------');
        print(response.body);
      } else {
        print('Failed to update. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating web address: $e');
    }
  }

  Future<void> updateCompanyName(String companyName) async {
    const String url =
        'http://localhost:8082/seller/seller-update-their-company-name';

    try {
      final response = await http.post(
        Uri.parse('$url?companyName=${Uri.encodeComponent(companyName)}'),
        headers: {
          'Authorization': 'Bearer $token',
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
      } else {
        print('Failed to update. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating company name: $e');
    }
  }

  Future<void> updateEmail(String newEmail) async {
    const String url = 'http://localhost:8082/seller/seller-update-their-email';

    try {
      final response = await http.post(
        Uri.parse('$url?email=${Uri.encodeComponent(newEmail)}'),
        headers: {
          'Authorization': 'Bearer $token',
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
      } else {
        print('Failed to update. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating email: $e');
    }
  }

  Future<void> updatePhoneNumber(String newPhoneNumber) async {
    const String url =
        'http://localhost:8082/seller/seller-update-their-phone-number';

    try {
      final response = await http.post(
        Uri.parse('$url?phoneNumber=${Uri.encodeComponent(newPhoneNumber)}'),
        headers: {
          'Authorization': 'Bearer $token',
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
      } else {
        print('Failed to update. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating phoneNumber: $e');
    }
  }

  Future<void> updateStreet(String newStreet) async {
    const String url =
        'http://localhost:8082/seller/seller-update-their-street-address';

    try {
      final response = await http.post(
        Uri.parse('$url?street=${Uri.encodeComponent(newStreet)}'),
        headers: {
          'Authorization': 'Bearer $token',
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
      } else {
        print('Failed to update. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating street: $e');
    }
  }

  Future<void> updateMetaTags(List<String> metaTags) async {
    const String url =
        'http://localhost:8082/seller/seller-update-their-meta-tags';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token', // Ensure token is included
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(metaTags), // Convert list to JSON
      );

      if (response.statusCode == 200) {
        print('Meta tags updated successfully!');
      } else {
        print(
            'Failed to update meta tags. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating meta tags: $e');
    }
  }

  Future<void> updateServicedZipCodes(List<String> zipCodes) async {
    const String url =
        'http://localhost:8082/seller/seller-update-their-serviced-zip-codes';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token', // Ensure token is included
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(zipCodes), // Convert list to JSON
      );

      if (response.statusCode == 200) {
        print('Zip codes services updated successfully!');
      } else {
        print(
            'Failed to update serviced zip codes. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating zip codes serviced: $e');
    }
  }
}
