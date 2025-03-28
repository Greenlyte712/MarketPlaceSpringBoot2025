import 'package:find_a_pro_pronto_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class ResetPasswordEmailPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordEmailPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String _message = "";

  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
      _message = "";
    });

    AuthService authService = AuthService();
    String response =
        await authService.requestResetPassword(_emailController.text);

    setState(() {
      _isLoading = false;
      _message = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reset Password")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Enter your email to reset your password",
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _resetPassword,
                    child: Text("Send Reset Link"),
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
