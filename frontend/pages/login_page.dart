import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _message = '';

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    final String? result = await _authService.login(
      _usernameController.text,
      _passwordController.text,
    );

    if (result != null && !result.startsWith('Login failed')) {
      List<dynamic> roles = _authService.getUserRoles(result);

      if (roles.contains('ROLE_SELLER')) {
        Navigator.pushNamed(context, '/seller-dashboard');
      } else if (roles.contains('ROLE_BUYER')) {
        Navigator.pushNamed(context, '/buyer-dashboard');
      } else {
        setState(() => _message = 'Unknown role: $roles');
      }
    } else {
      setState(() => _message = result ?? 'Unknown error');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(_usernameController, 'Username'),
            SizedBox(height: 16.0),
            _buildTextField(_passwordController, 'Password', isPassword: false),
            SizedBox(height: 16.0),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _handleLogin,
                    child: Text('Login'),
                  ),
            SizedBox(height: 16.0),
            Text(_message, style: TextStyle(color: Colors.red, fontSize: 16.0)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      decoration:
          InputDecoration(labelText: label, border: OutlineInputBorder()),
      obscureText: isPassword,
    );
  }
}
