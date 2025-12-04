class AccessibilitySettings {
  final double textScale;
  final bool highContrast;
  final bool reduceMotion;

  AccessibilitySettings({
    required this.textScale,
    required this.highContrast,
    required this.reduceMotion,
  });

  AccessibilitySettings copyWith({
    double? textScale,
    bool? highContrast,
    bool? reduceMotion,
  }) {
    return AccessibilitySettings(
      textScale: textScale ?? this.textScale,
      highContrast: highContrast ?? this.highContrast,
      reduceMotion: reduceMotion ?? this.reduceMotion,
    );
  }
}
