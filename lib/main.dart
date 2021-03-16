import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/screens/home_screen.dart';
import 'screens/login_page.dart';
import 'package:provider/provider.dart';

class UserState extends ChangeNotifier {
  /// Internal, private state of the cart.

  Map<String, dynamic> currentUser;

  /// Adds [item] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void userLogIn(Map<String, dynamic> user) {
    currentUser = user;
    print(currentUser);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes all items from the cart.
  void userLogOut() {
    // ignore: avoid_init_to_null
    User currentUser = null;
    print(currentUser);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print('App Initialized');
  // Uncomment this to use the auth emulator for testing
  // await FirebaseAuth.instance.useEmulator('http://localhost:9099');

  runApp(
      ChangeNotifierProvider(create: (context) => UserState(), child: MyApp()));
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
