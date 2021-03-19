import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:uuid/uuid.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
var uuid = Uuid();

// ignore: non_constant_identifier_names
Future create_a_chat(String currentUserID, String contactID) async {
  var chat = {
    "users": [contactID, currentUserID],
    "createdAt": DateTime.now(),
    "chats": [],
    "ChatRoomId": uuid.v1(),
    "updatedAt": DateTime.now(),
  };

  await firestore.collection("Chats").add(chat);
  print("Chat Created");

  return chat["ChatRoomId"];
}
