import 'package:firebase_auth/firebase_auth.dart';

import '../main.dart';

Future<void> signOut() async {
  final userstate = UserState();
  await FirebaseAuth.instance.signOut();
  userstate.userLogOut();
  print("User Signed out");
}
