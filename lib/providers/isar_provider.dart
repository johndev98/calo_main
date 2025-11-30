// isar_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/user_profile.dart';

// Provider cho Isar instance
final isarProvider = FutureProvider<Isar>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([UserProfileSchema], directory: dir.path);

  // Quan trọng: Đăng ký dispose callback
  ref.onDispose(() {
    isar.close(); // ⭐ ĐÓNG DATABASE KHI PROVIDER DISPOSE
    print('🔒 Isar database đã đóng');
  });

  return isar;
});

// Helper provider để truy cập Isar dễ dàng
final isarSyncProvider = Provider<Isar>((ref) {
  final isarAsync = ref.watch(isarProvider);
  return isarAsync.when(
    data: (isar) => isar,
    loading: () => throw Exception('Isar chưa sẵn sàng'),
    error: (err, stack) => throw err,
  );
});
