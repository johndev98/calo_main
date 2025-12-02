import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../../../theme/app_theme.dart';

class OnboardingProgressBar extends StatelessWidget {
  final double value;
  final VoidCallback onBack;

  const OnboardingProgressBar({
    super.key,
    required this.value,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final mix = MixTheme.of(context);

    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: mix.colors[AppTheme.$textPrimary],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  mix.radii[AppTheme.$radiusSmall] ?? const Radius.circular(8),
                ),
                child: LinearProgressIndicator(
                  value: value,
                  backgroundColor: mix.colors[AppTheme.$surface],
                  valueColor: AlwaysStoppedAnimation(
                    mix.colors[AppTheme.$gradient1],
                  ),
                  minHeight: 8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
