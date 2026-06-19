import 'package:flutter/material.dart';
import 'package:music_player/core/constants/constants.dart';
import 'package:music_player/core/widgets/loading.dart';
import 'package:music_player/extensions/extensions.dart';

const _brandMidnight = Color(0xFF060429);
const _brandBlue = Color(0xFF3559E6);
const _brandSky = Color(0xFF36C2FF);
const _brandGlow = Color(0xFFFFC857);

class BrandShowcase extends StatelessWidget {
  const BrandShowcase({
    required this.eyebrow,
    required this.title,
    required this.description,
    this.footer,
    this.centered = true,
    this.isProminent = false,
    super.key,
  });

  final String eyebrow;
  final String title;
  final String description;
  final Widget? footer;
  final bool centered;
  final bool isProminent;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;
    final textAlign = centered ? TextAlign.center : TextAlign.start;
    final crossAxisAlignment =
        centered ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isProminent ? 36 : 28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_brandMidnight, _brandBlue],
        ),
        boxShadow: [
          BoxShadow(
            color: _brandBlue.withValues(alpha: 0.28),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isProminent ? 36 : 28),
        child: Stack(
          children: [
            const Positioned(
              top: -72,
              right: -24,
              child: _BrandGlow(
                size: 180,
                color: _brandSky,
                opacity: 0.24,
              ),
            ),
            const Positioned(
              bottom: -90,
              left: -32,
              child: _BrandGlow(
                size: 220,
                color: _brandGlow,
                opacity: 0.18,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(isProminent ? 28 : 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: crossAxisAlignment,
                spacing: isProminent ? 18 : 14,
                children: [
                  _BrandCapsule(label: eyebrow),
                  _BrandLogo(size: isProminent ? 104 : 82),
                  Text(
                    title,
                    textAlign: textAlign,
                    style: textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontSize: isProminent ? 36 : 30,
                      height: 1.05,
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Text(
                      description,
                      textAlign: textAlign,
                      style: textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.5,
                      ),
                    ),
                  ),
                  if (footer != null) footer!,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppStartupSplash extends StatelessWidget {
  const AppStartupSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_brandMidnight, Color(0xFF10185A), Color(0xFF030215)],
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            top: -120,
            right: -60,
            child: _BrandGlow(
              size: 260,
              color: _brandSky,
              opacity: 0.18,
            ),
          ),
          const Positioned(
            bottom: -160,
            left: -80,
            child: _BrandGlow(
              size: 320,
              color: _brandGlow,
              opacity: 0.1,
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: BrandShowcase(
                  eyebrow: context.localization.brandTagline,
                  title: context.localization.brandName,
                  description: context.localization.brandSplashMessage,
                  isProminent: true,
                  footer: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 14,
                    children: [
                      const EqualizerLoading(
                        size: 58,
                      ),
                      Text(
                        context.localization.createdBy,
                        textAlign: TextAlign.center,
                        style: context.theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.82),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandCapsule extends StatelessWidget {
  const _BrandCapsule({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.18),
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: context.theme.textTheme.labelLarge?.copyWith(
          color: Colors.white,
        ),
      ).paddingSymmetric(horizontal: 16, vertical: 10),
    );
  }
}

class _BrandGlow extends StatelessWidget {
  const _BrandGlow({
    required this.size,
    required this.color,
    required this.opacity,
  });

  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: opacity),
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandLogo extends StatelessWidget {
  const _BrandLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.08),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.24),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsets.all(size * 0.14),
      child: Image.asset(ImageAssets.logo),
    );
  }
}
