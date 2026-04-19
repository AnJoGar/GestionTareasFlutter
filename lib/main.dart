import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_board/repositories/task_repository.dart';

import 'providers/task_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const TaskBoardApp());
}

class TaskBoardApp extends StatelessWidget {
  const TaskBoardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(
        TaskRepository(), // 👈 YA NO TaskStorageService
      ),
      child: MaterialApp(
        title: 'TaskBoard',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: false,
            elevation: 2,
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}