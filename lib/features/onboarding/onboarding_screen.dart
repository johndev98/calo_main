import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mix/mix.dart';

import '../../providers/user_profile_provider.dart';
import '../../theme/app_theme.dart';
import 'basic_info_screen.dart';
import 'diet_screen.dart';
import 'widgets/onboarding_progress_bar.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  double _progress = 0.25;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final page = _pageController.page ?? 0;
      setState(() {
        // Giả sử có 4 trang, tiến trình sẽ là 0.25, 0.5, 0.75, 1.0
        _progress = (page / 4) + 0.25;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onBack() {
    if (_pageController.page == 0) {
      ref.read(userProfileProvider.notifier).reset();
    } else {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mix = MixTheme.of(context);
    final pages = [
      BasicInfoPage(pageController: _pageController),
      DietPage(pageController: _pageController),
      // Thêm các trang khác ở đây
    ];

    return Scaffold(
      backgroundColor: mix.colors[AppTheme.$background],
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: mix.spaces[AppTheme.$spacingSmall] ?? 10),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: mix.spaces[AppTheme.$spacing] ?? 24,
              ),
              child: OnboardingProgressBar(value: _progress, onBack: _onBack),
            ),
            Expanded(
              child: PageView(controller: _pageController, children: pages),
            ),
          ],
        ),
      ),
    );
  }
}
