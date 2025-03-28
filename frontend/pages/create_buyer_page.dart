import 'package:flutter/material.dart';
import '../services/create_user_service.dart';
import '../widgets/create_buyer_form.dart';

class CreateBuyerPage extends StatefulWidget {
  @override
  _CreateBuyerPageState createState() => _CreateBuyerPageState();
}

class _CreateBuyerPageState extends State<CreateBuyerPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final CreateUserService _createUserService = CreateUserService();

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // Create user with role "ROLE_BUYER"
      await _createUserService.createUser(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        role: "ROLE_BUYER",
      );

      // Generate token after user creation
      final token = await _createUserService.generateToken(
        username: _usernameController.text,
        password: _passwordController.text,
      );

      // Create the buyer account
      await _createUserService.createBuyer(
        token: token,
        name: _nameController.text,
      );

      _showDialog("Success", "Buyer account created successfully!");
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
      appBar: AppBar(title: const Text("Register as a Buyer")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CreateBuyerForm(
          formKey: _formKey,
          usernameController: _usernameController,
          emailController: _emailController,
          passwordController: _passwordController,
          nameController: _nameController,
          onSubmit: _createAccount,
        ),
      ),
    );
  }
}
