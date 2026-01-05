import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:obatin/shared_prefs_helper.dart';
import 'package:obatin/splash_screen.dart';
import 'package:obatin/notification_service.dart';

void main() async {
  // Ensure that Flutter bindings are initialized before any Flutter code is executed.
  WidgetsFlutterBinding.ensureInitialized();

  // Set up logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  // Create default user for testing if it doesn't exist
  await SharedPreferencesHelper().ensureDefaultUserExists();

  // Initialize the notification service
  try {
    debugPrint('Starting notification service initialization...');
    await NotificationService().init();
    debugPrint('Notification service initialized successfully');
  } catch (e) {
    // If notification init fails, continue without it
    debugPrint('Notification service init failed: $e');
  }

  // Run the application
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Set the splash screen as the initial route.
      home: SplashScreen(),
    );
  }
}
