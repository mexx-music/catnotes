import 'package:flutter/material.dart';
import 'paw_divider.dart';

class CatNotesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CatNotesAppBar({super.key, this.actions});
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget catWithNotes() {
      return SizedBox(
        height: 44,
        width: 64,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/cat_notes_holder.png',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(Icons.pets, size: 28),
              color: isDark ? Colors.white.withOpacity(0.92) : null,
              colorBlendMode: isDark ? BlendMode.modulate : null,
            ),
          ],
        ),
      );
    }

    return AppBar(
      toolbarHeight: kToolbarHeight + 4,
      titleSpacing: 12,
      title: Row(
        children: [
          catWithNotes(),
          const SizedBox(width: 8),
          Text(
            'Cat Notes',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(8),
        child: Builder(builder: (context) {
          // leichte Anpassung nach Flair-Level
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final base = isDark ? 0.14 : 0.10;
          return Opacity(opacity: base, child: const PawDivider());
        }),
      ),
    );
  }
}
