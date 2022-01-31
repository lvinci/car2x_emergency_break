/// Represents the position of a car in Car2X
class Position {
  /// Create a new Position object with all parameters
  const Position({
    required this.latitude,
    required this.speed,
    required this.laneId,
  });

  /// Exact coordinates of the position.
  /// This is only as accurate as the car sensors are.
  /// No longitude is needed in this simulation as the lane id is enough.
  final double latitude;

  /// Current speed of the car in meters per second
  final double speed;

  /// The id of the lane that the car is in
  final int laneId;

  /// Get the speed in kilometers per hour instead of meters per second
  double get speedInKmh => speed * 3.6;
}
