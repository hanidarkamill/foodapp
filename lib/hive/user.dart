import 'package:hive/hive.dart';

part 'user.g.dart'; // File ini akan dihasilkan oleh build_runner

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String password;

  User({required this.username, required this.email, required this.password});
}
