// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<String> signInWithGoogle() async {
  // await Firebase.initializeApp();

  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential authResult =
      await _auth.signInWithCredential(credential);
  final User user = authResult.user;

  if (user != null) {
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);
    CollectionReference users = firestore.collection('Users');

    final storedUser =
        users.where("uid", isEqualTo: currentUser.uid).get().then(
              (value) => print(value),
            );
    if (storedUser == null) {
      users.add({
        "uid": currentUser.uid,
        "displayName": currentUser.displayName,
        "photoURL": currentUser.photoURL,
        "email": currentUser.email,
        "emailVerified": currentUser.emailVerified,
        "createdAt": DateTime.now()
      });
    }

    print('signInWithGoogle succeeded: $user');

    return '$user';
  }

  return null;
}
