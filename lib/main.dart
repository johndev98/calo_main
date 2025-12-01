import 'package:calo_main/features/onboarding/basic_info_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/user_profile.dart';
import 'providers/isar_provider.dart';
import 'providers/user_profile_provider.dart';
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
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: isarAsync.when(
        data: (isar) => const BasicInfoScreen(),
        loading: () => const CupertinoPageScaffold(
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (err, stack) => Scaffold(body: Center(child: Text('Lỗi: $err'))),
      ),
    );
  }
}
