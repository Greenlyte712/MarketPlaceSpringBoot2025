import 'package:flutter/material.dart';
import '../services/create_user_service.dart';
import '../widgets/create_seller_form.dart';

class CreateSellerPage extends StatefulWidget {
  @override
  _CreateSellerPageState createState() => _CreateSellerPageState();
}

class _CreateSellerPageState extends State<CreateSellerPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipcodeController = TextEditingController();
  final CreateUserService _createUserService = CreateUserService();

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await _createUserService.createUser(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        role: "ROLE_SELLER",
      );

      final token = await _createUserService.generateToken(
        username: _usernameController.text,
        password: _passwordController.text,
      );

      await _createUserService.createSeller(
        token: token,
        companyName: _companyNameController.text,
        phoneNumber: _phoneController.text,
        sellerAddress: {
          "street": _streetController.text,
          "city": _cityController.text,
          "state": _stateController.text,
          "zipcode": _zipcodeController.text,
        },
        email: _emailController.text,
      );

      _showDialog("Success", "Seller account created successfully!");
    } catch (e) {
      _showDialog("Error", e.toString());
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register as a Seller")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CreateSellerForm(
          formKey: _formKey,
          usernameController: _usernameController,
          emailController: _emailController,
          passwordController: _passwordController,
          companyNameController: _companyNameController,
          phoneController: _phoneController,
          streetController: _streetController,
          cityController: _cityController,
          stateController: _stateController,
          zipcodeController: _zipcodeController,
          onSubmit: _createAccount,
        ),
      ),
    );
  }
}
