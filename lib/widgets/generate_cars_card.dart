import 'package:flutter/material.dart';

/// Allows the user to generate new cars
class GenerateCarsCard extends StatefulWidget {
  const GenerateCarsCard({Key? key, required this.onGenerateCars})
      : super(key: key);

  /// Callback for generating new cars
  final ValueChanged<int> onGenerateCars;

  @override
  State<GenerateCarsCard> createState() => _GenerateCarsCardState();
}

/// Keeps the state of the amount of cars to be generated
class _GenerateCarsCardState extends State<GenerateCarsCard> {
  /// Amount of cars to be generated
  int _amount = 20;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 5),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              'Anzahl Autos',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Row(
              children: [
                Slider(
                  min: 10,
                  max: 40.0,
                  value: _amount.toDouble(),
                  divisions: 30,
                  onChanged: (a) => setState(() => _amount = a.toInt()),
                ),
                Text(
                  '$_amount Autos',
                  style: const TextStyle(
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => widget.onGenerateCars(_amount),
              child: const Text('Autos neu generieren'),
            ),
          ],
        ),
      ),
    );
  }
}
