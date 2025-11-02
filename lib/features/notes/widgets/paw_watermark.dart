import 'package:flutter/material.dart';

class PawWatermark extends StatelessWidget {
  const PawWatermark({super.key, required this.intensity});
  final int intensity; // 0..3

  @override
  Widget build(BuildContext context) {
    final alpha = [0.0, 0.05, 0.07, 0.09][intensity.clamp(0, 3)];
    return IgnorePointer(
      ignoring: true,
      child: CustomPaint(painter: _PawTiledPainter(alpha)),
    );
  }
}

class _PawTiledPainter extends CustomPainter {
  _PawTiledPainter(this.alpha);
  final double alpha;

  @override
  void paint(Canvas canvas, Size size) {
    if (alpha == 0) return;
    final textStyle = TextStyle(fontSize: 18, color: Color.fromRGBO(0, 0, 0, alpha));
    final tp = TextPainter(textDirection: TextDirection.ltr);
    for (double y = 16; y < size.height; y += 40) {
      for (double x = (y ~/ 40).isEven ? 20 : 40; x < size.width; x += 60) {
        tp.text = TextSpan(text: '🐾', style: textStyle);
        tp.layout();
        tp.paint(canvas, Offset(x, y));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PawTiledPainter old) => old.alpha != alpha;
}
