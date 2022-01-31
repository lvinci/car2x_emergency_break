import 'package:flutter/material.dart';
import 'package:notbrems_assistent/models/car.dart';
import 'package:notbrems_assistent/models/warning_action.dart';

class SimulationHighway extends StatelessWidget {
  const SimulationHighway({
    Key? key,
    required this.cars,
    required this.actions,
    required this.selectedCar,
    required this.onCarSelected,
  }) : super(key: key);

  final List<Car> cars;

  final List<WarningAction> actions;

  final ValueChanged<int> onCarSelected;

  final int selectedCar;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            _buildOuterBorder(),
            _buildLaneDivider(isSolid: true),
            _buildLane(),
            _buildLaneDivider(),
            _buildLane(),
            _buildLaneDivider(),
            _buildLane(),
            _buildLaneDivider(isSolid: true),
            _buildOuterBorder(),
          ],
        ),
        ..._buildCars(context),
      ],
    );
  }

  /// Builds all car widgets
  List<Widget> _buildCars(final BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return cars.map((car) => _buildCar(car, width)).toList();
  }

  /// Builds a car widget
  Widget _buildCar(final Car car, final double width) {
    final lanePositions = [32.0, 74.0, 116.0];
    // Calculate the car color
    Color? color;
    if (car.id == selectedCar) {
      color = Colors.blue;
    }
    final action = _getAction(car.id);
    if (action != null) {
      color = action.color;
    }
    return Positioned(
      left: (width / 100.0) * car.position.latitude,
      top: lanePositions[car.position.laneId - 1],
      child: InkWell(
        onTap: () => onCarSelected(car.id),
        child: Stack(
          children: [
            Image.asset(
              'assets/car_icon.png',
              height: 40,
              width: 50,
              fit: BoxFit.cover,
              color: color,
            ),
            SizedBox(
              width: 50,
              height: 40,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 3, left: 2),
                  child: Text(
                    car.id.toString(),
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a highway lane
  Widget _buildLane() {
    return Container(
      color: Colors.grey,
      height: 40,
    );
  }

  /// Builds the divider between lanes
  Widget _buildLaneDivider({final bool isSolid = false}) {
    if (isSolid) {
      return Container(
        height: 2,
        color: Colors.white,
      );
    }
    return Row(
      children: List.generate(51, (index) {
        return Expanded(
          child: Container(
            height: 2,
            color: index % 2 == 0 ? Colors.grey : Colors.white,
          ),
        );
      }),
    );
  }

  /// Builds the outer border of the highway
  Widget _buildOuterBorder() {
    return Container(
      color: Colors.grey,
      height: 25,
    );
  }

  /// Get the action for the given car id
  WarningAction? _getAction(final int carId) {
    for (final action in actions) {
      if (action.carId == carId) {
        return action;
      }
    }
    return null;
  }
}
