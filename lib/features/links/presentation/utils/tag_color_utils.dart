import 'package:flutter/material.dart';

class TagColorUtils {
  static const List<Color> _palette = [
    Color(0xFFEF4444),
    Color(0xFFF97316),
    Color(0xFFEAB308),
    Color(0xFF84CC16),
    Color(0xFF22C55E),
    Color(0xFF14B8A6),
    Color(0xFF06B6D4),
    Color(0xFF3B82F6),
    Color(0xFF6366F1),
    Color(0xFF8B5CF6),
    Color(0xFFD946EF),
    Color(0xFFEC4899),
  ];

  static Color colorForTag(String tag) {
    final normalized = tag.trim().toUpperCase();
    if (normalized.isEmpty) {
      return const Color(0xFF3B82F6);
    }

    var hash = 0;
    for (final codeUnit in normalized.codeUnits) {
      hash = (hash * 31 + codeUnit) & 0x7fffffff;
    }
    return _palette[hash % _palette.length];
  }
}
