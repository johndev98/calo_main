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

// class ProfilePage extends ConsumerStatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   ConsumerState<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends ConsumerState<ProfilePage> {
//   @override
//   Widget build(BuildContext context) {
//     final profile = ref.watch(userProfileProvider);
//     final notifier = ref.watch(themeProvider.notifier);
//     final theme = ref.watch(themeProvider);

//     return CupertinoPageScaffold(
//       navigationBar: const CupertinoNavigationBar(middle: Text('User Profile')),
//       child: SafeArea(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CupertinoButton.filled(
//                 onPressed: notifier.toggleTheme,
//                 child: Text(
//                   "Toggle Dark / Light",
//                   style: TextStyle(
//                     color: theme.brightness == Brightness.dark
//                         ? CupertinoColors.black
//                         : CupertinoColors.white,
//                   ),
//                 ),
//               ),

//               /// Reset Button
//               CupertinoButton.filled(
//                 color: CupertinoColors.activeBlue,
//                 onPressed: () {
//                   ref.read(userProfileProvider.notifier).resetProfile();
//                 },
//                 child: const Text("Reset Profile"),
//               ),

//               const SizedBox(height: 20),

//               Text('Gender: ${profile.gender.name}'),
//               Text('Age: ${profile.age}'),

//               const SizedBox(height: 20),

//               /// Male Button
//               CupertinoButton.filled(
//                 color: profile.gender == Gender.male
//                     ? CupertinoColors.activeBlue
//                     : CupertinoColors.systemGrey,
//                 onPressed: () {
//                   ref.read(userProfileProvider.notifier).setGender(Gender.male);
//                 },
//                 child: const Text('Male'),
//               ),

//               const SizedBox(height: 10),

//               /// Female Button
//               CupertinoButton.filled(
//                 color: profile.gender == Gender.female
//                     ? CupertinoColors.systemPink
//                     : CupertinoColors.systemGrey,
//                 onPressed: () {
//                   ref
//                       .read(userProfileProvider.notifier)
//                       .setGender(Gender.female);
//                 },
//                 child: const Text('Female'),
//               ),

//               const SizedBox(height: 20),

//               /// Next Button
//               CupertinoButton.filled(
//                 disabledColor: CupertinoColors.systemGrey,
//                 onPressed: profile.gender == Gender.none
//                     ? () => _showSelectGenderAlert(context)
//                     : () {
//                         debugPrint(
//                           "Tiếp tục với gender: ${profile.gender.name}, age: ${profile.age}",
//                         );
//                       },
//                 child: const Text("Next"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

/// Cupertino Alert
//   void _showSelectGenderAlert(BuildContext context) {
//     showCupertinoDialog(
//       context: context,
//       builder: (context) => CupertinoAlertDialog(
//         title: const Text("Thông báo"),
//         content: const Padding(
//           padding: EdgeInsets.only(top: 8),
//           child: Text("Vui lòng chọn giới tính trước khi tiếp tục."),
//         ),
//         actions: [
//           CupertinoDialogAction(
//             onPressed: () => Navigator.of(context).pop(),
//             isDefaultAction: true,
//             child: const Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }
// }
