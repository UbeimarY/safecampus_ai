import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FadeInDown(
          duration: const Duration(milliseconds: 600),
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.accent],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.4),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(
              Icons.shield_rounded,
              size: 50,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        FadeInDown(
          delay: const Duration(milliseconds: 200),
          child: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.white, AppColors.accent],
            ).createShader(bounds),
            child: const Text(
              AppStrings.appName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        FadeInDown(
          delay: const Duration(milliseconds: 300),
          child: const Text(
            AppStrings.tagline,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

