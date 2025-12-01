import 'package:isar/isar.dart';
part 'user_profile.g.dart'; // để Isar codegen

@collection
class UserProfile {
  Id id = 1; // primary key
  @enumerated
  late Gender gender;
  
  int? birthYear;
  int? height;
  int? weight;
}

enum Gender { male, female, none }

enum Diet { classic, vegetarian, vegan, pescatarian, keto }
