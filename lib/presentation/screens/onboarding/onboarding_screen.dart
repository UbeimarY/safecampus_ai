import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../logic/onboarding/onboarding_controller.dart';
import '../../widgets/onboarding/onboarding_page.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();

  void _nextPage(int pageIndex, int totalPages) {
    if (pageIndex < totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/login');
    }
  }

  void _skip() => context.go('/login');

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = ref.watch(onboardingPagesProvider);
    final onboardingState = ref.watch(onboardingControllerProvider);
    final pageIndex = onboardingState.pageIndex;
    final accentColor = pages[pageIndex].accentColor;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => ref
                .read(onboardingControllerProvider.notifier)
                .setPageIndex(index),
            itemCount: pages.length,
            itemBuilder: (context, index) => OnboardingPage(data: pages[index]),
          ),

          Positioned(
            top: 50,
            right: 20,
            child: pageIndex < pages.length - 1
                ? TextButton(
                    onPressed: _skip,
                    child: Text(
                      AppStrings.onboardingSkip,
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 50),
              child: Column(
                children: [
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: pageIndex == index ? 28 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: pageIndex == index
                              ? accentColor
                              : Colors.white24,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => _nextPage(pageIndex, pages.length),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                        shadowColor: accentColor.withValues(alpha: 0.5),
                      ),
                      child: Text(
                        pageIndex < pages.length - 1
                            ? AppStrings.onboardingNext
                            : AppStrings.onboardingStart,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
