import 'package:flutter/material.dart';

class SeniorCatTextView extends StatefulWidget {
  final String title;
  final String body;

  const SeniorCatTextView({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  State<SeniorCatTextView> createState() => _SeniorCatTextViewState();
}

class _SeniorCatTextViewState extends State<SeniorCatTextView> {
  late ScrollController _scrollController;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Berechnet die optimale Schriftgröße basierend auf Textlänge und Bildschirmgröße
  double _calculateOptimalFontSize(
    BuildContext context,
    String text,
  ) {
    final screenSize = MediaQuery.of(context).size;
    final textLength = text.length;

    // Basis-Schriftgröße basierend auf Bildschirmgröße
    final baseSize = screenSize.width > 800
        ? 48.0 // Tablet/Desktop
        : 36.0; // Mobil

    // Anpassung basierend auf Textlänge
    if (textLength < 100) {
      return baseSize * 1.2; // Kurzer Text: sehr groß
    } else if (textLength < 500) {
      return baseSize * 0.9; // Mittlerer Text: groß
    } else if (textLength < 1500) {
      return baseSize * 0.7; // Längerer Text: mittel
    } else {
      return baseSize * 0.6; // Sehr langer Text: kleiner, aber scrollbar
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fontSize = _calculateOptimalFontSize(context, widget.body);
        final bgColor = _isDarkMode ? Colors.black : Colors.white;
        final textColor = _isDarkMode ? Colors.white : Colors.black;

        return Container(
          color: bgColor,
          child: Column(
            children: [
              // Header mit Kontrollen
              Container(
                color: _isDarkMode
                    ? Colors.grey[900]
                    : Colors.grey[100],
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Zurück-Button
                    ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back, size: 24),
                      label: const Text(
                        'Zurück',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                    // Kontrast-Button
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() => _isDarkMode = !_isDarkMode);
                      },
                      icon: Icon(
                        _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        size: 24,
                      ),
                      label: Text(
                        _isDarkMode ? 'Hell' : 'Dunkel',
                        style: const TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Inhalts-Bereich
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Titel
                      if (widget.title.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: fontSize * 0.9,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              height: 1.4,
                            ),
                          ),
                        ),
                      // Body-Text
                      Text(
                        widget.body,
                        style: TextStyle(
                          fontSize: fontSize,
                          color: textColor,
                          height: 1.6,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
