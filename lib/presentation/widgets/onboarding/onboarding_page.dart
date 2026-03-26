import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../logic/onboarding/onboarding_models.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: data.gradientColors,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              FadeInDown(
                duration: const Duration(milliseconds: 700),
                child: OnboardingAnimatedIcon(data: data),
              ),
              const SizedBox(height: 48),
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: Text(
                  data.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: _HighlightedDescription(
                  text: data.description,
                  highlight: data.highlight,
                  accentColor: data.accentColor,
                ),
              ),
              const SizedBox(height: 20),
              FadeIn(
                delay: const Duration(milliseconds: 600),
                child: Container(
                  width: 60,
                  height: 3,
                  decoration: BoxDecoration(
                    color: data.accentColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 140),
            ],
          ),
        ),
      ),
    );
  }
}

class _HighlightedDescription extends StatelessWidget {
  final String text;
  final String highlight;
  final Color accentColor;

  const _HighlightedDescription({
    required this.text,
    required this.highlight,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final parts = text.split(highlight);
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 16,
          height: 1.6,
        ),
        children: [
          TextSpan(text: parts.first),
          TextSpan(
            text: highlight,
            style: TextStyle(
              color: accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (parts.length > 1) TextSpan(text: parts[1]),
        ],
      ),
    );
  }
}

class OnboardingAnimatedIcon extends StatefulWidget {
  final OnboardingPageData data;

  const OnboardingAnimatedIcon({super.key, required this.data});

  @override
  State<OnboardingAnimatedIcon> createState() => _OnboardingAnimatedIconState();
}

class _OnboardingAnimatedIconState extends State<OnboardingAnimatedIcon>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _orbitController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _orbitAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _orbitAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _orbitController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _orbitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseAnimation, _orbitAnimation]),
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.data.accentColor.withValues(alpha: 0.15),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.data.accentColor.withValues(alpha: 0.08),
                  border: Border.all(
                    color: widget.data.accentColor.withValues(alpha: 0.25),
                    width: 1.5,
                  ),
                ),
              ),
              Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.data.accentColor.withValues(alpha: 0.15),
                    boxShadow: [
                      BoxShadow(
                        color: widget.data.accentColor.withValues(alpha: 0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.data.icon,
                    size: 60,
                    color: widget.data.accentColor,
                  ),
                ),
              ),
              ...List.generate(widget.data.particles.length, (index) {
                final angle = _orbitAnimation.value +
                    (index * 2 * math.pi / widget.data.particles.length);
                const radius = 115.0;
                return Positioned(
                  left: 140 + radius * math.cos(angle) - 16,
                  top: 140 + radius * math.sin(angle) - 16,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.data.accentColor.withValues(alpha: 0.2),
                      border: Border.all(
                        color: widget.data.accentColor.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      widget.data.particles[index],
                      size: 16,
                      color: widget.data.accentColor,
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
