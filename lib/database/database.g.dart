// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDB {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDBBuilder databaseBuilder(String name) => _$AppDBBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDBBuilder inMemoryDatabaseBuilder() => _$AppDBBuilder(null);
}

class _$AppDBBuilder {
  _$AppDBBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDBBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDBBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDB> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDB();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDB extends AppDB {
  _$AppDB([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TripDAO? _tripDAOInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Trip` (`tripId` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `destination` TEXT NOT NULL, `date` TEXT NOT NULL, `assessment` INTEGER NOT NULL, `description` TEXT, `expectedCost` REAL, `membersAmount` INTEGER)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TripDAO get tripDAO {
    return _tripDAOInstance ??= _$TripDAO(database, changeListener);
  }
}

class _$TripDAO extends TripDAO {
  _$TripDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _tripInsertionAdapter = InsertionAdapter(
            database,
            'Trip',
            (Trip item) => <String, Object?>{
                  'tripId': item.tripId,
                  'name': item.name,
                  'destination': item.destination,
                  'date': item.date,
                  'assessment': item.assessment ? 1 : 0,
                  'description': item.description,
                  'expectedCost': item.expectedCost,
                  'membersAmount': item.membersAmount
                }),
        _tripUpdateAdapter = UpdateAdapter(
            database,
            'Trip',
            ['tripId'],
            (Trip item) => <String, Object?>{
                  'tripId': item.tripId,
                  'name': item.name,
                  'destination': item.destination,
                  'date': item.date,
                  'assessment': item.assessment ? 1 : 0,
                  'description': item.description,
                  'expectedCost': item.expectedCost,
                  'membersAmount': item.membersAmount
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Trip> _tripInsertionAdapter;

  final UpdateAdapter<Trip> _tripUpdateAdapter;

  @override
  Future<List<Trip>> getAllTrips() async {
    return _queryAdapter.queryList('SELECT * FROM Trip',
        mapper: (Map<String, Object?> row) => Trip(
            tripId: row['tripId'] as int?,
            name: row['name'] as String,
            destination: row['destination'] as String,
            date: row['date'] as String,
            assessment: (row['assessment'] as int) != 0,
            description: row['description'] as String?,
            expectedCost: row['expectedCost'] as double?,
            membersAmount: row['membersAmount'] as int?));
  }

  @override
  Future<Trip?> findTripById(int tripId) async {
    return _queryAdapter.query('SELECT * FROM Trip WHERE tripId = ?1',
        mapper: (Map<String, Object?> row) => Trip(
            tripId: row['tripId'] as int?,
            name: row['name'] as String,
            destination: row['destination'] as String,
            date: row['date'] as String,
            assessment: (row['assessment'] as int) != 0,
            description: row['description'] as String?,
            expectedCost: row['expectedCost'] as double?,
            membersAmount: row['membersAmount'] as int?),
        arguments: [tripId]);
  }

  @override
  Future<void> deleteTrip(int tripId) async {
    await _queryAdapter.queryNoReturn('DELETE FROM Trip WHERE tripId = ?1',
        arguments: [tripId]);
  }

  @override
  Future<void> insertTrip(Trip trip) async {
    await _tripInsertionAdapter.insert(trip, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTrip(Trip trip) async {
    await _tripUpdateAdapter.update(trip, OnConflictStrategy.abort);
  }
}
