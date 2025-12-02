import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mix/mix.dart';

import '../../models/user_profile.dart';
import '../../providers/user_profile_provider.dart';
import '../../theme/app_theme.dart';

class DietPage extends ConsumerWidget {
  final PageController pageController;

  const DietPage({super.key, required this.pageController});

  void _onNextPressed(BuildContext context, UserProfile profile) {
    if (profile.diet == Diet.none) {
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text("Chưa chọn chế độ ăn"),
          content: const Text("Vui lòng chọn một chế độ ăn để tiếp tục."),
          actions: [
            CupertinoDialogAction(
              child: const Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    } else {
      // Chuyển đến trang tiếp theo hoặc hoàn thành
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final notifier = ref.read(userProfileProvider.notifier);
    final mix = MixTheme.of(context);
    final isComplete = profile.diet != Diet.none;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: mix.spaces[AppTheme.$spacing] ?? 24,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Chế độ ăn của bạn",
                  style: mix.textStyles[AppTheme.$heading],
                ),
                Text(
                  "Nhấn giữ để biết thêm thông tin",
                  style: mix.textStyles[AppTheme.$label]?.copyWith(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 4,
            child: Center(
              child: Column(
                spacing: 20,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _DietOption(
                    title: '🍽️ Bình thường',
                    isSelected: profile.diet == Diet.classic,
                    onTap: () => notifier.update(diet: Diet.classic),
                  ),
                  _DietOption(
                    title: '🥕 Chay',
                    isSelected: profile.diet == Diet.vegetarian,
                    onTap: () => notifier.update(diet: Diet.vegetarian),
                  ),
                  _DietOption(
                    title: '🌱 Thuần chay',
                    isSelected: profile.diet == Diet.vegan,
                    onTap: () => notifier.update(diet: Diet.vegan),
                  ),
                  _DietOption(
                    title: '🐟 🥦 Ăn cá & thực vật',
                    isSelected: profile.diet == Diet.pescatarian,
                    onTap: () => notifier.update(diet: Diet.pescatarian),
                  ),
                  _DietOption(
                    title: '🥑 Keto',
                    isSelected: profile.diet == Diet.keto,
                    onTap: () => notifier.update(diet: Diet.keto),
                  ),
                ],
              ),
            ),
          ),

          // Continue Button
          GestureDetector(
            onTap: () => _onNextPressed(context, profile),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: mix.spaces[AppTheme.$spacingSmall]!,
              ),
              constraints: const BoxConstraints(maxWidth: 400),
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                gradient: isComplete
                    ? LinearGradient(
                        colors: [
                          mix.colors[AppTheme.$gradient1]!,
                          mix.colors[AppTheme.$gradient2]!,
                        ],
                      )
                    : null,
                color: isComplete ? null : mix.colors[AppTheme.$surface],
                borderRadius: BorderRadius.all(
                  mix.radii[AppTheme.$radiusLarge]!,
                ),
                border: Border.all(
                  color: mix.colors[AppTheme.$border]!,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  "Tiếp tục",
                  style: mix.textStyles[AppTheme.$textButton]?.copyWith(
                    color: isComplete ? Colors.white : null,
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

class _DietOption extends StatelessWidget {
  const _DietOption({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final mix = MixTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: mix.spaces[AppTheme.$spacingSmall]!,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? mix.colors[AppTheme.$primary]
              : mix.colors[AppTheme.$surface],
          borderRadius: BorderRadius.all(mix.radii[AppTheme.$radiusLarge]!),
        ),
        child: Center(
          child: Text(
            title,
            style: mix.textStyles[AppTheme.$actionText]?.copyWith(
              color: isSelected ? Colors.white : null,
            ),
          ),
        ),
      ),
    );
  }
}
