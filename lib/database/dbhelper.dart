import 'package:assignment/database/database.dart';

class DatabaseHelper {
  final String databaseName = 'trip_expense.db';
  Future<AppDB> build() async =>
      await $FloorAppDB.databaseBuilder(databaseName).build();
}
