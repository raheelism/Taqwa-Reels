import 'package:flutter/material.dart';

/// Categories for Pixabay background search.
const kBackgroundCategories = <String>[
  'mosque',
  'nature',
  'sky',
  'ocean',
  'desert',
  'stars',
  'sunset',
  'mountain',
];

/// Preset text color options for overlays (hex strings).
const kTextColorPresets = <String>[
  '#FFFFFF', // White
  '#C8A24E', // Gold
  '#E8C96E', // Light Gold
  '#A0AAC4', // Silver
  '#4A9EE0', // Blue
  '#4CAF50', // Green
  '#FFB74D', // Orange
  '#EF5350', // Red
];

/// Helper to convert hex string to Color.
Color hexToColor(String hex) {
  return Color(int.parse(hex.replaceFirst('#', '0xFF')));
}
