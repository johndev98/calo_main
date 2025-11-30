import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/user_profile.dart';
import 'providers/isar_provider.dart';
import 'providers/user_profile_provider.dart';

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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Theo dõi app lifecycle
    if (state == AppLifecycleState.detached) {
      print('📱 App bị detached - Database sẽ tự động đóng qua provider');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isarAsync = ref.watch(isarProvider);

    return MaterialApp(
      home: isarAsync.when(
        data: (isar) => const ProfilePage(),
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (err, stack) => Scaffold(
          body: Center(child: Text('Lỗi: $err')),
        ),
      ),
    );
  }
}

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                ref.read(userProfileProvider.notifier).resetProfile();
              },
              child: const Text("Reset Profile"),
            ),
            const SizedBox(height: 20),
            Text('Gender: ${profile.gender.name}'),
            Text('Age: ${profile.age}'),
            const SizedBox(height: 20),
        
            // chọn Male
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    profile.gender == Gender.male ? Colors.blue : Colors.grey,
              ),
              onPressed: () {
                ref.read(userProfileProvider.notifier).setGender(Gender.male);
              },
              child: const Text('Male'),
            ),
        
            const SizedBox(height: 10),
        
            // chọn Female
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    profile.gender == Gender.female ? Colors.pink : Colors.grey,
              ),
              onPressed: () {
                ref.read(userProfileProvider.notifier).setGender(Gender.female);
              },
              child: const Text('Female'),
            ),
        
            const SizedBox(height: 20),
        
            // Nút Next
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: profile.gender == Gender.none
                    ? Colors.grey
                    : Colors.deepOrange,
              ),
              onPressed: () {
                if (profile.gender == Gender.none) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Thông báo"),
                      content: const Text(
                          "Vui lòng chọn giới tính trước khi tiếp tục."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                } else {
                  debugPrint(
                      "Tiếp tục với gender: ${profile.gender.name}, age: ${profile.age}");
                }
              },
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
