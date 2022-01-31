import 'package:flutter/material.dart';

/// Represents the different types of actions that can be made by a car
enum ActionType { nothing, breaking, emergencyBreaking }

/// Represents the actionthat is performed by a car
class WarningAction {
  /// Create a new warning action object
  const WarningAction({
    required this.carId,
    required this.distance,
    required this.laneDistance,
    required this.type,
    required this.risk,
  });

  /// The id of the car that is performing the action
  final int carId;

  /// The distance to the other car in meters
  final double distance;

  /// The distance in lanes to the car
  final int laneDistance;

  /// Which action will be taken
  final ActionType type;

  /// The risk in percent
  final double risk;

  /// Distance text for lanes
  String get laneDistanceText {
    if (laneDistance == 0) {
      return 'gleiche Spur';
    }
    if (laneDistance == 1) {
      return '1 Spur entfernt';
    }
    return '$laneDistance Spuren entfernt';
  }

  /// Get the text of the action that is performed
  String get typeText {
    if (type == ActionType.emergencyBreaking) {
      return 'Notbremsung';
    }
    if (type == ActionType.breaking) {
      return 'Bremsen';
    }
    return 'nichts';
  }

  /// Color displayed for this action
  Color? get color {
    if (type == ActionType.emergencyBreaking) {
      return Colors.red;
    }
    if (type == ActionType.breaking) {
      return Colors.yellow;
    }
    return null;
  }
}
