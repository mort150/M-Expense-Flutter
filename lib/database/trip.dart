import 'dart:ffi';

import 'package:floor/floor.dart';

@entity
class Trip {
  @PrimaryKey(autoGenerate: true)
  int? tripId;
  String name;
  String destination;
  String date;
  bool assessment;
  String? description;
  double? expectedCost;
  int? membersAmount;

  Trip(
      {this.tripId,
      required this.name,
      required this.destination,
      required this.date,
      required this.assessment,
      this.description,
      this.expectedCost,
      this.membersAmount});
}
