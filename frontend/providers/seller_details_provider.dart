import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:find_a_pro_pronto_app/services/update_info_service.dart';

class SellerDetailsProvider extends ChangeNotifier {
  final String token;
  Map<String, dynamic>? sellerDetails;
  bool isLoading = true;
  String? errorMessage;
  late UpdateInfoService updateInfoService;

  SellerDetailsProvider({required this.token}) {
    updateInfoService = UpdateInfoService(token);
    fetchSellerDetails();
  }

  Future<void> fetchSellerDetails() async {
    const String url = 'http://localhost:8082/seller/seller-view-their-details';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200) {
        sellerDetails = json.decode(response.body);
      } else {
        errorMessage =
            'Failed to load seller details. Status code: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage = 'Error occurred: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateField(String fieldKey, String newValue) async {
    switch (fieldKey) {
      case "companyDescription":
        await updateInfoService.updateCompanyDescription(newValue);
        break;
      case "webAddress":
        await updateInfoService.updateWebAddress(newValue);
        break;
      case "companyName":
        await updateInfoService.updateCompanyName(newValue);
      case "email":
        await updateInfoService.updateEmail(newValue);
      case "phoneNumber":
        await updateInfoService.updatePhoneNumber(newValue);
      case "street":
        await updateInfoService.updateStreet(newValue);
      default:
        // Handle case if the fieldKey doesn't match any known cases
        break;
    }

    if (sellerDetails != null) {
      if (["street", "zipcode", "city", "state"].contains(fieldKey)) {
        // Update the field within the 'sellerAddress' object
        sellerDetails!['sellerAddress'][fieldKey] = newValue;
      } else {
        // Update the field at the root level
        sellerDetails![fieldKey] = newValue;
      }
      notifyListeners();
    }
  }

  Future<void> updateMetaTags(List<String> updatedTags) async {
    await updateInfoService.updateMetaTags(updatedTags);
    if (sellerDetails != null) {
      sellerDetails!['metaTags'] = updatedTags;
    }
    notifyListeners();
  }

  Future<void> updateServicedZipCodes(List<String> servicedZipCodes) async {
    await updateInfoService.updateServicedZipCodes(servicedZipCodes);
    if (sellerDetails != null) {
      sellerDetails!['servicedZipCodes'] = servicedZipCodes;
    }
    notifyListeners();
  }
}
