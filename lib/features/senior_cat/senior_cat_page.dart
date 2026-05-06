import 'package:flutter/material.dart';
import 'senior_cat_text_view.dart';

class SeniorCatPage extends StatelessWidget {
  final String title;
  final String body;

  const SeniorCatPage({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SeniorCatTextView(
        title: title,
        body: body,
      ),
    );
  }
}
