import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
var uuid = Uuid();

// ignore: non_constant_identifier_names
Future<void> create_a_chat(User currentUser, User contact) async {
  var chat = {
    "recipient": contact,
    "createdAt": DateTime.now(),
    "chats": [],
    "uuid": uuid.v1()
  };

  await firestore.collection("Chats").add(chat);
  print("Chat Created");
}
