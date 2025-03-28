import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:find_a_pro_pronto_app/providers/seller_details_provider.dart';

class SellerViewDetailsPage extends StatelessWidget {
  final String token;

  const SellerViewDetailsPage({required this.token});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SellerDetailsProvider(token: token),
      child: Scaffold(
        appBar: AppBar(title: const Text('Seller Details')),
        body: Consumer<SellerDetailsProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.errorMessage != null) {
              return Center(
                child: Text(
                  provider.errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              );
            }

            if (provider.sellerDetails == null) {
              return const Center(child: Text('No seller details available.'));
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildEditableField(
                      context,
                      'Company Name',
                      provider.sellerDetails!['companyName'],
                      'companyName',
                      provider.updateField,
                    ),
                    buildEditableField(
                      context,
                      'Email',
                      provider.sellerDetails!['email'],
                      'email',
                      provider.updateField,
                    ),
                    buildEditableField(
                      context,
                      'Phone Number',
                      provider.sellerDetails!['phoneNumber'],
                      'phoneNumber',
                      provider.updateField,
                    ),
                    buildEditableField(
                      context,
                      'Street',
                      provider.sellerDetails!['sellerAddress']['street'],
                      'street',
                      provider.updateField,
                    ),
                    buildEditableField(
                      context,
                      'City',
                      provider.sellerDetails!['sellerAddress']['city'],
                      'city',
                      provider.updateField,
                    ),
                    buildEditableField(
                      context,
                      'State',
                      provider.sellerDetails!['sellerAddress']['state'],
                      'state',
                      provider.updateField,
                    ),
                    buildEditableField(
                      context,
                      'Zipcode',
                      provider.sellerDetails!['sellerAddress']['zipcode'],
                      'zipcode',
                      provider.updateField,
                    ),
                    buildEditableField(
                      context,
                      'Website',
                      provider.sellerDetails!['webAddress'],
                      'webAddress',
                      provider.updateField,
                    ),
                    buildEditableField(
                      context,
                      'Description of services provided:',
                      provider.sellerDetails!['companyDescription'],
                      'companyDescription',
                      provider.updateField,
                    ),
                    buildMetaTagsField(
                        provider.sellerDetails!['metaTags'] ?? [],
                        provider.updateMetaTags,
                        context),
                    const SizedBox(height: 20),
                    buildServicedZipCodesField(
                        provider.sellerDetails!['servicedZipCodes'] ?? [],
                        provider.updateServicedZipCodes,
                        context),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildEditableField(
    BuildContext context,
    String label,
    dynamic value,
    String fieldKey,
    Future<void> Function(String fieldKey, String newValue) updateField,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ${value ?? "Not Available"}',
          style: const TextStyle(fontSize: 18),
        ),
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: () => showUpdateDialog(
            context,
            fieldKey,
            value as String?,
            updateField,
          ),
        ),
      ],
    );
  }

  void showUpdateDialog(
    BuildContext context,
    String fieldKey,
    String? currentValue,
    Future<void> Function(String fieldKey, String newValue) updateField,
  ) {
    TextEditingController controller =
        TextEditingController(text: currentValue ?? "");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update ${fieldKey.replaceAll('_', ' ')}'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter new value'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String newValue = controller.text;
                await updateField(fieldKey, newValue);
                Navigator.pop(context); // Close dialog
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Widget buildMetaTagsField(
    List<dynamic> metaTags,
    Future<void> Function(List<String>) updateMetaTags,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tags:', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: metaTags
              .map<Widget>((tag) => Chip(
                    label: Text(tag),
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () async {
                      List<String> updatedTags = List.from(metaTags)
                        ..remove(tag);
                      await updateMetaTags(updatedTags);
                    },
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => showAddTagDialog(context, metaTags, updateMetaTags),
          child: const Text('Add Tag'),
        ),
      ],
    );
  }

  void showAddTagDialog(BuildContext context, List<dynamic> metaTags,
      Future<void> Function(List<String>) updateMetaTags) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Tag'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter new tag'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String newTag = controller.text.trim();
                if (newTag.isNotEmpty) {
                  List<String> updatedTags = List.from(metaTags)..add(newTag);
                  await updateMetaTags(updatedTags);
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget buildServicedZipCodesField(
    List<dynamic> servicedZipCodes,
    Future<void> Function(List<String>) updateServicedZipCodes,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Serviced Zip Codes:', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: servicedZipCodes
              .map<Widget>((zipCode) => Chip(
                    label: Text(zipCode),
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () async {
                      List<String> updatedServicedZipCodes =
                          List.from(servicedZipCodes)..remove(zipCode);
                      await updateServicedZipCodes(updatedServicedZipCodes);
                    },
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => showAddServicedZipCodesDialog(
              context, servicedZipCodes, updateServicedZipCodes),
          child: const Text('Add Serviced Zip Code'),
        ),
      ],
    );
  }

  void showAddServicedZipCodesDialog(
      BuildContext context,
      List<dynamic> zipCodes,
      Future<void> Function(List<String>) updateServicedZipCodes) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Serviced Zip Code'),
          content: TextField(
            controller: controller,
            decoration:
                const InputDecoration(hintText: 'Enter new serviced zip code'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String newZip = controller.text.trim();
                if (newZip.isNotEmpty) {
                  List<String> updatedZipCodes = List.from(zipCodes)
                    ..add(newZip);
                  await updateServicedZipCodes(updatedZipCodes);
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
