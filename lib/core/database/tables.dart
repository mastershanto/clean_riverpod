import 'package:drift/drift.dart';

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get phone => text()();
  TextColumn get address => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Auth extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get token => text()();
  TextColumn get refreshToken => text()();
  TextColumn get response => text()(); // API response
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get expiresAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
