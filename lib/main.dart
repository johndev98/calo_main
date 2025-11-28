import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/user_profile.dart';
import 'providers/isar_provider.dart';
import 'providers/user_profile_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isarAsync = ref.watch(isarFutureProvider);
    return MaterialApp(
      home: isarAsync.when(
        data: (isar) => const ProfilePage(),
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (err, stack) => Scaffold(body: Center(child: Text('Lỗi: $err'))),
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
  late FixedExtentScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileProvider);
    _scrollController = FixedExtentScrollController(
      initialItem: (profile.age - 16).clamp(0, 84),
    );

    // Lắng nghe thay đổi profile; chỉ animate khi age thay đổi
    ref.listen<UserProfile>(userProfileProvider, (previous, next) {
      final prevAge = previous?.age;
      final nextAge = next.age;
      if (prevAge == null || prevAge == nextAge) return;

      final targetIndex = (nextAge - 16).clamp(0, 84);
      // animate nhẹ đến vị trí mới
      _scrollController.animateToItem(
        targetIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: Column(
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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: profile.gender == Gender.male
                  ? Colors.blue
                  : Colors.grey,
            ),
            onPressed: () {
              ref.read(userProfileProvider.notifier).setGender(Gender.male);
              debugPrint('Current gender: ${Gender.male.name}');
            },
            child: const Text('Male'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: profile.gender == Gender.female
                  ? Colors.pink
                  : Colors.grey,
            ),
            onPressed: () {
              ref.read(userProfileProvider.notifier).setGender(Gender.female);
              debugPrint('Current gender: ${Gender.female.name}');
            },
            child: const Text('Female'),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: CupertinoPicker(
              magnification: 1.2,
              useMagnifier: true,
              itemExtent: 40,
              scrollController: _scrollController,
              onSelectedItemChanged: (index) {
                final age = 16 + index;
                ref.read(userProfileProvider.notifier).setAge(age);
                debugPrint('Current age: $age');
              },
              children: List.generate(
                85,
                (index) => Center(child: Text('${16 + index}')),
              ),
            ),
          ),
          SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: profile.gender == Gender.none
                  ? Colors.grey
                  : Colors.deepOrange,
            ),
            child: const Text("Next"),
            onPressed: () {
              if (profile.gender == Gender.none) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Thông báo"),
                    content: const Text(
                      "Vui lòng chọn giới tính trước khi tiếp tục.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                );
              } else {
                debugPrint("Tiếp tục với gender: ${profile.gender.name}");
                debugPrint("Tiếp tục với age: ${profile.age}");
              }
            },
          ),
        ],
      ),
    );
  }
}
