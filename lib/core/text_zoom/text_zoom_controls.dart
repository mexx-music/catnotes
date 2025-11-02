import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'text_zoom_scope.dart';

class IncreaseTextSizeIntent extends Intent {}
class DecreaseTextSizeIntent extends Intent {}

class TextZoomControls extends StatelessWidget {
  final Widget child;
  const TextZoomControls({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final controller = TextZoomScope.of(context);

    final shortcuts = <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.equal, control: true): IncreaseTextSizeIntent(),
      SingleActivator(LogicalKeyboardKey.equal, meta: true): IncreaseTextSizeIntent(),
      SingleActivator(LogicalKeyboardKey.add, control: true): IncreaseTextSizeIntent(),
      SingleActivator(LogicalKeyboardKey.add, meta: true): IncreaseTextSizeIntent(),
      SingleActivator(LogicalKeyboardKey.minus, control: true): DecreaseTextSizeIntent(),
      SingleActivator(LogicalKeyboardKey.minus, meta: true): DecreaseTextSizeIntent(),
      SingleActivator(LogicalKeyboardKey.numpadSubtract, control: true): DecreaseTextSizeIntent(),
      SingleActivator(LogicalKeyboardKey.numpadSubtract, meta: true): DecreaseTextSizeIntent(),
    };

    return Shortcuts(
      shortcuts: shortcuts,
      child: Actions(
        actions: <Type, Action<Intent>>{
          IncreaseTextSizeIntent: CallbackAction<IncreaseTextSizeIntent>(onInvoke: (_) { controller.increase(); return null; }),
          DecreaseTextSizeIntent: CallbackAction<DecreaseTextSizeIntent>(onInvoke: (_) { controller.decrease(); return null; }),
        },
        child: Focus(
          autofocus: true,
          child: Stack(
            children: [
              child,
              Positioned(
                left: 12, bottom: 12,
                child: Material(
                  elevation: 3, borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.surface,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Schrift kleiner',
                        icon: const Icon(Icons.remove),
                        onPressed: () => controller.decrease(),
                      ),
                      Builder(builder: (_) {
                        return AnimatedBuilder(
                          animation: controller,
                          builder: (context, __) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text('Aa ${controller.size.toInt()}'),
                          ),
                        );
                      }),
                      IconButton(
                        tooltip: 'Schrift größer',
                        icon: const Icon(Icons.add),
                        onPressed: () => controller.increase(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

