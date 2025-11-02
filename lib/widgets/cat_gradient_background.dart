import 'package:flutter/material.dart';

class CatGradientBackground extends StatelessWidget {
  final Widget child;
  const CatGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final List<Color> lightColors = [
      const Color(0xFFFFF8E7), // cream
      const Color(0xFFFFE0D2), // peach
      const Color(0xFFFFD6E0), // light pink
    ];
    final List<Color> darkColors = [
      const Color(0xFF2D1B4C), // deep purple
      const Color(0xFF1A223F), // dark blue
      const Color(0xFF44475A), // soft gray
    ];
    final colors = isDark ? darkColors : lightColors;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(seconds: 4),
      curve: Curves.easeInOut,
      builder: (context, value, childWidget) {
        final stops = [0.0, 0.5 + 0.1 * (0.5 - (value - 0.5).abs()), 1.0];
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
              stops: stops,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _PawOverlay(isDark: isDark),
              // Katze IMMER im Hintergrund, nicht nur bei ListView
              Positioned.fill(
                child: IgnorePointer(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/cat_notes_holder.png',
                          width: 200,
                          fit: BoxFit.contain,
                          color: isDark
                              ? Colors.white.withOpacity(0.13)
                              : Colors.black.withOpacity(0.10),
                          colorBlendMode: BlendMode.srcATop,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Noch keine Notizen 🐾\nDie Katze hält den Block bereit!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: isDark
                                  ? Colors.white.withOpacity(0.55)
                                  : Colors.black.withOpacity(0.55),
                            ),
                      ),
                      const SizedBox(height: 8),
                      Icon(Icons.pets, size: 36, color: isDark ? Colors.white38 : Colors.black26),
                    ],
                  ),
                ),
              ),
              if (childWidget != null) childWidget,
            ],
          ),
        );
      },
    );
  }
}

class _PawOverlay extends StatelessWidget {
  final bool isDark;
  const _PawOverlay({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final pawColor = isDark
        ? Colors.white.withOpacity(0.08)
        : Colors.black.withOpacity(0.08);
    final pawSize = 44.0;
    final pawSpacing = 120.0;
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cols = (constraints.maxWidth / pawSpacing).ceil();
          final rows = (constraints.maxHeight / pawSpacing).ceil();
          return Stack(
            children: [
              for (int y = 0; y < rows; y++)
                for (int x = 0; x < cols; x++)
                  Positioned(
                    left: x * pawSpacing + (y.isEven ? 0 : pawSpacing / 2),
                    top: y * pawSpacing,
                    child: Icon(
                      Icons.pets,
                      size: pawSize,
                      color: pawColor,
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}
