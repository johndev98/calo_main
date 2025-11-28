import 'package:isar/isar.dart';
part 'user_profile.g.dart'; // để Isar codegen

@collection
class UserProfile {
  Id id = 1; // primary key

  @enumerated
  late Gender gender;

  int age = 18;
}

enum Gender { male, female, other, none }
enum Diet {classic, pescatarian, vegan, vegetarian, keto}