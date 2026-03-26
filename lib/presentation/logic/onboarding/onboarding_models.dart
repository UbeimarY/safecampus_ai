import 'package:flutter/material.dart';

class OnboardingPageData {
  final IconData icon;
  final String title;
  final String description;
  final String highlight;
  final List<Color> gradientColors;
  final Color accentColor;
  final List<IconData> particles;

  const OnboardingPageData({
    required this.icon,
    required this.title,
    required this.description,
    required this.highlight,
    required this.gradientColors,
    required this.accentColor,
    required this.particles,
  });
}

