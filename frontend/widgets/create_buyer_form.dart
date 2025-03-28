import 'package:flutter/material.dart';

class CreateBuyerForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final VoidCallback onSubmit;

  const CreateBuyerForm({
    required this.formKey,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.nameController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(usernameController, "Username"),
              _buildTextField(emailController, "Email", email: true),
              _buildTextField(
                passwordController,
                "Password",
                obscureText: true,
                password: true,
              ),
              _buildTextField(nameController, "Full Name"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onSubmit,
                child: const Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool obscureText = false, bool email = false, bool password = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: password
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  // Toggle password visibility
                  obscureText = !obscureText;
                },
              )
            : null,
      ),
      obscureText: obscureText,
      validator: (value) {
        if (value!.isEmpty) return "Enter a $label";
        if (email &&
            !RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(value))
          return "Enter a valid email address";
        return null;
      },
    );
  }
}
