import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/services/auth/auth_gate.dart';
import 'package:untitled2/themes/light_mode.dart';



Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(options: const FirebaseOptions(
        apiKey: "AIzaSyDOEzXUNeKGkwvvW3XWSokpGrDSoB5POS4",
        appId: "1:963347198841:android:db911fc5fc307f5cd335a8",
        messagingSenderId: "963347198841",
        projectId: "chatappflutter-3a255"
    ));
  }

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: lightMode,
    );
  }
}

