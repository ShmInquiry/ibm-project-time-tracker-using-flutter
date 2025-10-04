import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/TimeEntryProvider.dart';
import 'services/ProjectTaskProvider.dart';
import 'screens/HomeScreenTimeTracker.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => TimeEntryProvider()..loadEntries()),
      ChangeNotifierProvider(
          create: (_) => ProjectTaskProvider()
            ..loadProjects()
            ..loadTasks()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: lattice80_5_hex,
          dividerColor: lattice80_3_hex,
          indicatorColor: lattice80_2_hex),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: lattice80_3_hex,
          dividerColor: lattice80_5_hex,
          indicatorColor: lattice80_2_hex),
      themeMode: ThemeMode.system,
      home: HomeScreen(),
    );
  }
}

// Define the colors using the hex values
const Color lattice80_1_hex = Color(0xFFF23041);
const Color lattice80_2_hex = Color(0xFFF2388F);
const Color lattice80_3_hex = Color(0xFFABA0F2);
const Color lattice80_4_hex = Color(0xFF9FD948);
const Color lattice80_5_hex = Color(0xFFF27329);
