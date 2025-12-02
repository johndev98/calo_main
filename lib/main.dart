import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mix/mix.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'providers/isar_provider.dart';
import 'theme/theme_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isarAsync = ref.watch(isarProvider);
    final theme = ref.watch(themeProvider);
    final mixTheme = ref.watch(mixThemeProvider);

    return MixTheme(
      data: mixTheme,
      child: CupertinoApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: isarAsync.when(
          // isarAsync.when() vẫn hữu ích để đảm bảo isar sẵn sàng
          data: (isar) => const OnboardingScreen(),
          loading: () => const CupertinoPageScaffold(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (err, stack) =>
              Scaffold(body: Center(child: Text('Lỗi: $err'))),
        ),
      ),
    );
  }
}
