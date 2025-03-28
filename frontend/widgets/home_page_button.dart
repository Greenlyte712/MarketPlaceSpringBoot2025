import 'package:flutter/material.dart';

class HomePageButton extends StatelessWidget {
  final String text;
  final String route;

  const HomePageButton({required this.text, required this.route});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      child: Text(text),
    );
  }
}
