import 'package:flutter/material.dart';
import 'package:notbrems_assistent/screens/simulation_screen.dart';

/// Main function of the application that starts the flutter app
void main() {
  runApp(const NotbremsAssistentSimulator());
}

/// Root widget of the app
class NotbremsAssistentSimulator extends StatelessWidget {
  const NotbremsAssistentSimulator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notbrems-Assistent Simulator',
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      initialRoute: '/',
      routes: {
        '/': (context) => const SimulationScreen(),
      },
    );
  }
}
