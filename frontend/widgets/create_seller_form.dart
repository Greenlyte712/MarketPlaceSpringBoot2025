import 'package:flutter/material.dart';

class CreateSellerForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController companyNameController;
  final TextEditingController phoneController;
  final TextEditingController streetController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController zipcodeController;
  final VoidCallback onSubmit;

  const CreateSellerForm({
    required this.formKey,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.companyNameController,
    required this.phoneController,
    required this.streetController,
    required this.cityController,
    required this.stateController,
    required this.zipcodeController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(usernameController, "Username"),
            _buildTextField(emailController, "Email"),
            _buildTextField(passwordController, "Password", obscureText: false),
            _buildTextField(companyNameController, "Company Name"),
            _buildTextField(phoneController, "Phone Number"),
            _buildTextField(streetController, "Street"),
            _buildTextField(cityController, "City"),
            _buildTextField(stateController, "State"),
            _buildTextField(zipcodeController, "Zipcode"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onSubmit,
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      obscureText: obscureText,
      validator: (value) => value!.isEmpty ? "Enter a $label" : null,
    );
  }
}
