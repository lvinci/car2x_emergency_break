import 'package:flutter/material.dart';
import 'package:notbrems_assistent/models/car.dart';
import 'package:notbrems_assistent/models/emergency_break_warning.dart';

/// Allows the user to send a warning of the current car
class SendWarningCard extends StatefulWidget {
  const SendWarningCard({
    Key? key,
    required this.onSendWarning,
    required this.selectedCar,
  }) : super(key: key);

  /// Callback for when a warning is sent
  final ValueChanged<EmergencyBreakWarning> onSendWarning;

  /// The currently selected car
  final Car selectedCar;

  @override
  State<SendWarningCard> createState() => _SendWarningCardState();
}

/// Keepos the state of the selected deceleration speed
class _SendWarningCardState extends State<SendWarningCard> {
  /// Currently selected deceleration speed
  double _decelerationSpeed = 5.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              'Bremsverzögerung',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Row(
              children: [
                Slider(
                  min: 1.0,
                  max: 9.99,
                  value: _decelerationSpeed,
                  onChanged: (s) => setState(() => _decelerationSpeed = s),
                ),
                Text(
                  '${_decelerationSpeed.toStringAsFixed(2)} m/s²',
                  style: const TextStyle(
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Car2X Nachricht JSON',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              padding: const EdgeInsets.all(10),
              child: SelectableText(
                warningMessage.jsonMessage,
                style: const TextStyle(
                  color: Colors.green,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _sendWarning,
              child: const Text('Notbremswarnung senden'),
            ),
          ],
        ),
      ),
    );
  }

  /// Generates the warning message for the current values
  EmergencyBreakWarning get warningMessage => EmergencyBreakWarning(
        senderId: widget.selectedCar.id,
        position: widget.selectedCar.position,
        decelerationSpeed: _decelerationSpeed,
        timestamp: DateTime.now(),
      );

  /// Sends the warning to the parent widget
  void _sendWarning() => widget.onSendWarning(warningMessage);
}
