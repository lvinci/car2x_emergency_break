import 'package:flutter/material.dart';
import 'package:notbrems_assistent/models/warning_action.dart';

/// Displays a table of all actions that will be made by cars
class CarActionCard extends StatelessWidget {
  const CarActionCard({Key? key, required this.actions}) : super(key: key);

  /// List of actions that will be made by the cars
  final List<WarningAction> actions;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(right: 10, top: 20, bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: DataTable(
          columns: const [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Distanz')),
            DataColumn(label: Text('Spur')),
            DataColumn(label: Text('Risiko')),
            DataColumn(label: Text('Aktion')),
          ],
          rows: actions
              .map((action) => DataRow(
                    color: WidgetStatePropertyAll<Color>(
                      action.color?.withOpacity(0.2) ?? Colors.transparent,
                    ),
                    cells: [
                      DataCell(
                        Text(action.carId.toString()),
                      ),
                      DataCell(
                        Text('${(action.distance * 3).toStringAsFixed(2)}m'),
                      ),
                      DataCell(
                        Text(action.laneDistanceText),
                      ),
                      DataCell(
                        Text('${action.risk.toStringAsFixed(2)} %'),
                      ),
                      DataCell(
                        Text(action.typeText),
                      ),
                    ],
                  ))
              .toList(),
        ),
      ),
    );
  }
}
