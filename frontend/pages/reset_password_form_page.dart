import 'package:find_a_pro_pronto_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class ResetPasswordFormPage extends StatefulWidget {
  final String token;

  ResetPasswordFormPage({required this.token});

  @override
  _ResetPasswordFormPageState createState() => _ResetPasswordFormPageState();
}

class _ResetPasswordFormPageState extends State<ResetPasswordFormPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _message = "";

  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
      _message = "";
    });

    AuthService authService = AuthService();
    String response =
        await authService.resetPassword(widget.token, _passwordController.text);

    setState(() {
      _isLoading = false;
      _message = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Set New Password")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Enter your new password", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: false,
              decoration: InputDecoration(
                labelText: "New Password",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _resetPassword,
                    child: Text("Reset Password"),
                  ),
            SizedBox(height: 20),
            if (_message.isNotEmpty)
              Text(
                _message,
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
