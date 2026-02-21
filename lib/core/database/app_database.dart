import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Users])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // User operations
  Future<List<User>> getAllUsers() => select(users).get();

  Future<User?> getUserById(String id) =>
      (select(users)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<int> insertUser(UsersCompanion userCompanion) =>
      into(users).insert(userCompanion);

  Future<bool> updateUser(User user) => update(users).replace(user);

  Future<int> deleteUser(String id) =>
      (delete(users)..where((tbl) => tbl.id.equals(id))).go();

  Future<void> deleteAllUsers() => delete(users).go();

  Stream<List<User>> watchAllUsers() => select(users).watch();

  Stream<User?> watchUserById(String id) =>
      (select(users)..where((tbl) => tbl.id.equals(id))).watchSingleOrNull();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'clean_riverpod.db'));
    return NativeDatabase(file);
  });
}
