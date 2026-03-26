import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_states.dart';
import 'onboarding_models.dart';
import 'package:flutter/material.dart';

final onboardingPagesProvider = Provider<List<OnboardingPageData>>((ref) {
  return const [
    OnboardingPageData(
      icon: Icons.shield_rounded,
      title: AppStrings.onboard1Title,
      description: AppStrings.onboard1Desc,
      highlight: 'risk areas',
      gradientColors: [Color(0xFF0A0E21), Color(0xFF0D2137)],
      accentColor: Color(0xFF00BCD4),
      particles: [Icons.location_on, Icons.warning_rounded, Icons.visibility],
    ),
    OnboardingPageData(
      icon: Icons.map_rounded,
      title: AppStrings.onboard2Title,
      description: AppStrings.onboard2Desc,
      highlight: 'reporting',
      gradientColors: [Color(0xFF0A0E21), Color(0xFF0D3724)],
      accentColor: Color(0xFF4CAF50),
      particles: [Icons.camera_alt, Icons.send_rounded, Icons.people_rounded],
    ),
    OnboardingPageData(
      icon: Icons.psychology_rounded,
      title: AppStrings.onboard3Title,
      description: AppStrings.onboard3Desc,
      highlight: 'safer routes',
      gradientColors: [Color(0xFF0A0E21), Color(0xFF1A1037)],
      accentColor: Color(0xFF00E5FF),
      particles: [Icons.route_rounded, Icons.analytics_rounded, Icons.notifications_active],
    ),
  ];
});

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>((ref) {
  return OnboardingController();
});

class OnboardingController extends StateNotifier<OnboardingState> {
  OnboardingController() : super(const OnboardingState());

  void setPageIndex(int index) {
    state = state.copyWith(pageIndex: index);
  }
}

