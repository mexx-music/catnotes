import 'package:flutter/widgets.dart';
import 'text_zoom_scope.dart';

class ZoomableMessageText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextStyle? style;
  const ZoomableMessageText(
    this.text, {super.key, this.textAlign, this.maxLines, this.overflow, this.style});

  @override
  Widget build(BuildContext context) {
    final controller = TextZoomScope.of(context);
    final base = style ?? const TextStyle();
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: base.copyWith(fontSize: controller.size),
      ),
    );
  }
}

