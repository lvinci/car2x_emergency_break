import 'package:notbrems_assistent/models/position.dart';

/// Represents a car used in the Car2X simulation
class Car {
  /// Create a new car object
  Car({
    required this.id,
    required this.position,
  });

  /// Dummy car object
  Car.dummy()
      : id = 0,
        position = const Position(latitude: 0, speed: 0, laneId: 0);

  /// Unique id number of this car
  final int id;

  /// Current position of this car.
  /// The position is updated as the car moves.
  Position position;
}
