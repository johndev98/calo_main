import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/user_profile.dart';
import 'isar_provider.dart';

class UserProfileNotifier extends Notifier<UserProfile> {
  @override
  UserProfile build() {
    final isar = ref.watch(isarProvider);

    // Lấy profile nếu có, nếu chưa thì tạo mới với gender = none
    final profile = isar.userProfiles.where().findFirstSync();
    if (profile != null) {
      return profile;
    } else {
      final newProfile = UserProfile()
        ..id = 1
        ..gender = Gender.none
        ..age = 0;
      isar.writeTxnSync(() => isar.userProfiles.putSync(newProfile));
      return newProfile;
    }
  }

  Future<void> setGender(Gender gender) async {
    final isar = ref.read(isarProvider);

    final updated = UserProfile()
      ..id = state.id
      ..gender = gender
      ..age = state.age;

    await isar.writeTxn(() async {
      await isar.userProfiles.put(updated);
    });

    state = updated; // gán object mới → UI rebuild ngay
  }

  Future<void> setAge(int age) async {
    final isar = ref.read(isarProvider);

    final updated = UserProfile()
      ..id = state.id
      ..gender = state.gender
      ..age = age;

    await isar.writeTxn(() async {
      await isar.userProfiles.put(updated);
    });

    state = updated;
  }

  /// Reset toàn bộ dữ liệu về mặc định
  Future<void> resetProfile() async {
    final isar = ref.read(isarProvider);

    final reset = UserProfile()
      ..id = 1
      ..gender = Gender.none
      ..age = 18;

    await isar.writeTxn(() async {
      await isar.userProfiles.put(reset);
    });

    state = reset; // cập nhật lại state để UI rebuild ngay
  }
}

final userProfileProvider = NotifierProvider<UserProfileNotifier, UserProfile>(
  () => UserProfileNotifier()
);
