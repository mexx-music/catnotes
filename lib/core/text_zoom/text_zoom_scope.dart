import 'package:flutter/widgets.dart';
import 'text_zoom_controller.dart';

class TextZoomScope extends InheritedNotifier<TextZoomController> {
  const TextZoomScope({
    super.key,
    required TextZoomController controller,
    required Widget child,
  }) : super(notifier: controller, child: child);

  static TextZoomController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<TextZoomScope>();
    assert(scope != null, 'TextZoomScope not found in context');
    return scope!.notifier!;
  }
}

