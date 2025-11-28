
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/user_profile.dart';

// FutureProvider để khởi tạo Isar
final isarFutureProvider = FutureProvider<Isar>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [UserProfileSchema],
    directory: dir.path,
  );
  return isar;
});
// Provider để dùng Isar sau khi đã khởi tạo
final isarProvider = Provider<Isar>((ref) {
  final isar = ref.watch(isarFutureProvider).value;
  if (isar == null) {
    throw UnimplementedError('Isar chưa sẵn sàng');
  }
  return isar;
});