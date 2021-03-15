import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/screens/home_screen.dart';
import 'screens/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print('App Initialized');
  // Uncomment this to use the auth emulator for testing
  // await FirebaseAuth.instance.useEmulator('http://localhost:9099');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    User firebaseUser = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      title: 'Flutter Chats',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.lightBlue[200],
        accentColor: Color(0xFFFEF9EB),
      ),
      home: firebaseUser != null ? HomeScreen() : LoginPage(),
    );
  }
}
