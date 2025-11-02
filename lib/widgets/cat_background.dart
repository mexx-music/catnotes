import 'package:flutter/material.dart';

class CatBackground extends StatelessWidget {
  const CatBackground({super.key, required this.child, required this.level});
  final Widget child;
  final int level;

  @override
  Widget build(BuildContext context) {
    if (level < 2) return child;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF121212), const Color(0xFF141520)]
              : [const Color(0xFFF9F7F6), const Color(0xFFF6F5F9)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}

