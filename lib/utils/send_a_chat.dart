import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_ui/utils/make_a_chat.dart';
import 'package:uuid/uuid.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
var uuid = Uuid();

//Todo - find auth User info using provider

// ignore: non_constant_identifier_names
Future<void> send_a_chat(String userId, String msg, String contactID,
    [String chatRoomId]) async {
  final currentUserData = await firestore
      .collection("Users")
      .doc(userId)
      .get()
      .then((snapshot) => snapshot.data());

  if (chatRoomId == null) {
    chatRoomId = await create_a_chat(userId, contactID);
  }

  var chat = {
    "sender": currentUserData,
    "sentTime": DateTime.now(),
    "msg": msg,
  };

  final chats = await firestore
      .collection("Chats")
      .doc(chatRoomId)
      .get()
      .then((doc) => doc.data());
  List chatsList = chats["chats"];
// ignore: sdk_version_ui_as_code
  var newchats = [...chatsList, chat];
  await firestore
      .collection("Chats")
      .doc(chatRoomId)
      .update({"chats": newchats})
      .then((res) => print("chat Sent"))
      .catchError((onError) => {print(onError)});
}
