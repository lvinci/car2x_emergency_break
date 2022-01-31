import 'dart:convert';

import 'package:notbrems_assistent/models/position.dart';
import 'package:notbrems_assistent/models/warning_action.dart';

/// Represents a Car2X message that a car sends out when the emergency break
/// is applied.
/// The message is not forwarded using hops because the range does not have to
/// be that high.
class EmergencyBreakWarning {
  /// Create a new emergency break warning object with all required parameters
  const EmergencyBreakWarning({
    required this.senderId,
    required this.position,
    required this.decelerationSpeed,
    required this.timestamp,
  });

  /// The unique id of the car that has sent the message
  final int senderId;

  /// The position of the car that is applying the emergency break
  final Position position;

  /// The deceleration speed of the car in meters per second squared
  final double decelerationSpeed;

  /// Timestamp of the time when the message was created
  final DateTime timestamp;

  /// Get a sample json message that is supposed to represent
  /// the message as a car2x message
  String get jsonMessage {
    final decel = (decelerationSpeed * 100).roundToDouble() / 100.0;
    final lat = (position.latitude * 100000).roundToDouble() / 100000.0;
    final json = {
      'sender_id': senderId,
      'deceleration_speed': decel,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'position': {
        'latitude': lat,
        'lane_id': position.laneId,
        'speed': position.speed,
      }
    };
    return const JsonEncoder.withIndent("     ").convert(json);
  }

  /// Calculates the risk of a crash with the given factors
  double calculateRisk(
    final double speed,
    final int laneDistance,
    final double distance,
  ) {
    if (laneDistance > 1 || distance.isNegative) {
      return 0;
    }
    final distanceTarget = position.speed - decelerationSpeed;
    final distanceSelf = speed;
    final distanceDifference = (distanceSelf - distanceTarget) / 10;
    final risk = distanceDifference * (100 - distance);
    return risk.clamp(0, 100);
  }

  /// Calculates which action to take regarding the given risk
  ActionType calculateAction(final double risk) {
    if (risk > 60) {
      return ActionType.emergencyBreaking;
    }
    if (risk > 30) {
      return ActionType.breaking;
    }
    return ActionType.nothing;
  }
}
