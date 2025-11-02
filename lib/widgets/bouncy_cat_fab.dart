import 'package:flutter/material.dart';

class BouncyCatFab extends StatefulWidget {
  const BouncyCatFab({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  State<BouncyCatFab> createState() => _BouncyCatFabState();
}

class _BouncyCatFabState extends State<BouncyCatFab> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 140), lowerBound: 0.0, upperBound: 0.10);
  @override void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _c.forward(),
      onTapUp: (_) => _c.reverse(),
      onTapCancel: () => _c.reverse(),
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, child) {
          final scale = 1 - _c.value;
          return Transform.scale(scale: scale, child: child);
        },
        child: FloatingActionButton(
          onPressed: widget.onPressed,
          child: const Icon(Icons.pets, size: 28),
        ),
      ),
    );
  }
}
