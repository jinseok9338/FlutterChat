import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
var uuid = Uuid();

// ignore: non_constant_identifier_names
Future<void> send_a_chat(User user, String msg, String chatroomId) async {
  var message = {
    "sender": user,
    "createdAt": DateTime.now(),
    "message": msg,
    "uuid": uuid.v1()
  };

  await firestore
      .collection("Chats")
      .where("uuid", isEqualTo: chatroomId)
      .get()
      .then((QuerySnapshot querySnapshot) => {
            querySnapshot.docs.forEach((doc) {
              print(doc);
              //check the doc data and update the chat array
            })
          })
      .catchError((onError) => print(onError));
  print("Message Sent");
}
