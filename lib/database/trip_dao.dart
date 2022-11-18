import 'package:assignment/database/trip.dart';
import 'package:floor/floor.dart';

@dao
abstract class TripDAO {
  @insert
  Future<void> insertTrip(Trip trip);

  @Query("SELECT * FROM Trip WHERE tripId = :tripId")
  Future<Trip?> findTripById(int tripId);

  @Query("SELECT * FROM Trip")
  Future<List<Trip>> getAllTrips();

  @update
  Future<void> updateTrip(Trip trip);

  @Query("DELETE FROM Trip WHERE tripId = :tripId")
  Future<void> deleteTrip(int tripId);
}
