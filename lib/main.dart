import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teaching_flutter_crud/firebase_options.dart';
import 'package:teaching_flutter_crud/screens/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Request location permission before starting the app
  await requestLocationPermission();

  runApp(const MyApp());
}

Future<void> requestLocationPermission() async {
  // Check the current permission status
  var status = await Permission.location.request();

  if (status.isGranted) {
    // Permission granted
    print("Location permission granted.");
  } else if (status.isDenied) {
    // Permission denied
    print("Location permission denied.");
  } else if (status.isPermanentlyDenied) {
    // Permission permanently denied
    print("Location permission permanently denied. Open settings to enable.");
    await openAppSettings(); // Open app settings for the user
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Dashboard(),
    );
  }
}
