import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notbrems_assistent/models/car.dart';
import 'package:notbrems_assistent/models/emergency_break_warning.dart';
import 'package:notbrems_assistent/models/position.dart';
import 'package:notbrems_assistent/models/warning_action.dart';
import 'package:notbrems_assistent/widgets/car_action_card.dart';
import 'package:notbrems_assistent/widgets/generate_cars_card.dart';
import 'package:notbrems_assistent/widgets/send_warning_card.dart';
import 'package:notbrems_assistent/widgets/simulation_highway.dart';

/// Displays the simulation of cars
class SimulationScreen extends StatefulWidget {
  const SimulationScreen({Key? key}) : super(key: key);

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

/// Keeps the current state of the simulation
class _SimulationScreenState extends State<SimulationScreen> {
  /// Cars visible in the simulation
  final List<Car> _cars = [];

  /// List of actions taken by all cars
  final List<WarningAction> _actions = [];

  /// unique id of the currently selected car
  int _selectedCar = 0;

  @override
  void initState() {
    _generateCars();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        child: ListView(
          children: [
            SimulationHighway(
              cars: _cars,
              actions: _actions,
              selectedCar: _selectedCar,
              onCarSelected: (id) => setState(() => _selectedCar = id),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SendWarningCard(
                      onSendWarning: _onWarningSent,
                      selectedCar: _cars.firstWhere(
                        (c) => c.id == _selectedCar,
                        orElse: Car.dummy,
                      ),
                    ),
                    GenerateCarsCard(
                      onGenerateCars: (amount) => setState(
                        () => _generateCars(amount: amount),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: CarActionCard(actions: _actions),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Generates 20 random cars
  void _generateCars({final int amount = 20}) {
    // Clear the previous actions
    _actions.clear();
    _selectedCar = 0;
    _cars.clear();
    for (int i = 1; i <= amount; i++) {
      var car = _generateCar(id: i);
      while (_isTooClose(car)) {
        car = _generateCar(id: i);
      }
      _cars.add(car);
    }
  }

  /// Generates a new car with random position
  Car _generateCar({final int id = 0}) {
    final random = Random();
    return Car(
      id: id,
      position: Position(
        latitude: random.nextDouble() * 100.0,
        speed: 30,
        laneId: random.nextInt(3) + 1,
      ),
    );
  }

  /// Checks whether the generated car is too close to any existing car
  /// Returns true if the car is too close and false otherwise.
  bool _isTooClose(final Car car) {
    for (final otherCar in _cars) {
      final isSameLane = otherCar.position.laneId == car.position.laneId;
      final distance = otherCar.position.latitude - car.position.latitude;
      final isTooClose = distance < 4 && distance > -4;
      if (isSameLane && isTooClose) {
        return true;
      }
    }
    return false;
  }

  void _onWarningSent(final EmergencyBreakWarning warning) {
    // Skip calculation if no car is selected
    if (warning.senderId == 0) {
      return;
    }
    setState(() {
      // Clear the previous actions
      _actions.clear();
      // Calculate the actions for every car
      for (final car in _cars) {
        // Do not calculate risk for the sender car
        if (car.id == warning.senderId) continue;
        // Calculate the lane distance to the car that is breaking
        var laneDistance = car.position.laneId - warning.position.laneId;
        if (laneDistance.isNegative) {
          laneDistance *= -1;
        }
        // Calculate the distance in meters to the car that is breaking
        final distance = car.position.latitude - warning.position.latitude;
        // Calculate the risk and desired action
        final risk = warning.calculateRisk(
          car.position.speed,
          laneDistance,
          distance,
        );
        final type = warning.calculateAction(risk);
        // Add the action to the list of actions
        _actions.add(
          WarningAction(
            carId: car.id,
            distance: distance,
            laneDistance: laneDistance,
            risk: risk,
            type: type,
          ),
        );
      }
      // Sort the list by risk from highest to lowest
      _actions.sort((a1, a2) => (a2.risk - a1.risk).toInt());
    });
  }
}
