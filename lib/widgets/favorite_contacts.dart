import 'package:flutter/material.dart';
// import 'package:flutter_chat_ui/models/message_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'favorite_contacts_class.dart';

class FavoriteContacts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        return FavoriteContactsWidgets(snapshot: snapshot);
      },
    );
  }
}

// ignore: must_be_immutable
