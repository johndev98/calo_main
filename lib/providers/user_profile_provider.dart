import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../models/user_profile.dart';
import 'isar_provider.dart';

class UserProfileNotifier extends Notifier<UserProfile> {
  @override
  UserProfile build() {
    final isar = ref.watch(isarSyncProvider);

    final profile = isar.userProfiles.where().findFirstSync();

    if (profile != null) {
      return profile;
    }

    final initial = UserProfile()
      ..id = 1
      ..gender = Gender.none
      ..birthYear = null
      ..weight = null
      ..height = null;

    isar.writeTxnSync(() => isar.userProfiles.putSync(initial));

    return initial;
  }

  Future<void> update({
    Gender? gender,
    int? birthYear,
    int? height,
    int? weight,
  }) async {
    final isar = ref.read(isarSyncProvider);

    final updated = UserProfile()
      ..id = state.id
      ..gender = gender ?? state.gender
      ..birthYear = birthYear ?? state.birthYear
      ..height = height ?? state.height
      ..weight = weight ?? state.weight;

    await isar.writeTxn(() async {
      await isar.userProfiles.put(updated);
    });

    state = updated;
  }

  Future<void> reset() async {
    final isar = ref.read(isarSyncProvider);

    final reset = UserProfile()
      ..id = 1
      ..gender = Gender.none
      ..birthYear = null
      ..weight = null
      ..height = null;

    await isar.writeTxn(() async {
      await isar.userProfiles.put(reset);
    });

    state = reset;
  }
}

final userProfileProvider =
    NotifierProvider<UserProfileNotifier, UserProfile>(
  () => UserProfileNotifier(),
);
