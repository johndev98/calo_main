// user_profile_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/user_profile.dart';
import 'isar_provider.dart';

class UserProfileNotifier extends Notifier<UserProfile> {
  @override
  UserProfile build() {
    final isar = ref.watch(isarSyncProvider); // Sử dụng sync provider

    final profile = isar.userProfiles.where().findFirstSync();
    if (profile != null) {
      return profile;
    } else {
      final newProfile = UserProfile()
        ..id = 1
        ..gender = Gender.none
        ..age = 18;
      isar.writeTxnSync(() => isar.userProfiles.putSync(newProfile));
      return newProfile;
    }
  }

  // Các method khác giữ nguyên...
  Future<void> setGender(Gender gender) async {
    final isar = ref.read(isarSyncProvider); // Sử dụng sync provider

    final updated = UserProfile()
      ..id = state.id
      ..gender = gender
      ..age = state.age;

    await isar.writeTxn(() async {
      await isar.userProfiles.put(updated);
    });

    state = updated;
  }

  Future<void> setAge(int age) async {
    final isar = ref.read(isarSyncProvider); // Sử dụng sync provider

    final updated = UserProfile()
      ..id = state.id
      ..gender = state.gender
      ..age = age;

    await isar.writeTxn(() async {
      await isar.userProfiles.put(updated);
    });

    state = updated;
  }

  Future<void> resetProfile() async {
    final isar = ref.read(isarSyncProvider); // Sử dụng sync provider

    final reset = UserProfile()
      ..id = 1
      ..gender = Gender.none
      ..age = 18;

    await isar.writeTxn(() async {
      await isar.userProfiles.put(reset);
    });

    state = reset;
  }
}

final userProfileProvider = NotifierProvider<UserProfileNotifier, UserProfile>(
  () => UserProfileNotifier(),
);
