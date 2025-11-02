import 'package:flutter/material.dart';

class PawDivider extends StatelessWidget {
  const PawDivider({super.key, this.opacity = 0.10});
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8,
      child: CustomPaint(painter: _PawLinePainter(opacity)),
    );
  }
}

class _PawLinePainter extends CustomPainter {
  _PawLinePainter(this.opacity);
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      fontSize: 12,
      color: Color.fromRGBO(0, 0, 0, opacity),
      height: 1.0,
    );
    final tp = TextPainter(textDirection: TextDirection.ltr);
    double x = 8;
    while (x < size.width - 8) {
      tp.text = TextSpan(text: '🐾', style: textStyle);
      tp.layout();
      tp.paint(canvas, Offset(x, -2));
      x += tp.width + 10;
    }
  }
  @override
  bool shouldRepaint(covariant _PawLinePainter old) =>
      old.opacity != opacity;
}
