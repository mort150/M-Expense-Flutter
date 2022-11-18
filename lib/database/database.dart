import 'dart:async';

import 'package:assignment/database/trip.dart';
import 'package:assignment/database/trip_dao.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 1, entities: [Trip])
abstract class AppDB extends FloorDatabase {
  TripDAO get tripDAO;
}
