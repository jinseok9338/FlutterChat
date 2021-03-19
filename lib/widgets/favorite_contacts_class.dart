import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_chat_ui/screens/home_screen.dart';

// ignore: must_be_immutable
class FavoriteContactsWidgets extends StatefulWidget {
  AsyncSnapshot<QuerySnapshot> snapshot;
  FavoriteContactsWidgets({Key key, this.snapshot}) : super(key: key) {
    // print("snapshot is $snapshot");
    // var favorites = snapshot.data.docs.map((doc) => doc.data()).toList();
    // print(favorites);
  }

  @override
  _FavoriteContactsWidgetsState createState() =>
      _FavoriteContactsWidgetsState();
}

class _FavoriteContactsWidgetsState extends State<FavoriteContactsWidgets> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    var favoritesWithMe =
        widget.snapshot.data.docs.map((doc) => doc.data()).toList();
    var favorites =
        favoritesWithMe.where((i) => i["uid"] != auth.currentUser.uid).toList();
    print(favorites);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Favorite Contacts',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                  ),
                  iconSize: 30.0,
                  color: Colors.blueGrey,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Container(
            height: 120.0,
            child: ListView.builder(
              padding: EdgeInsets.only(left: 10.0),
              scrollDirection: Axis.horizontal,
              itemCount: favorites.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomeScreen(),
                      // builder: (_) => ChatScreen(user: favorites[index]),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 35.0,
                          backgroundImage:
                              NetworkImage(favorites[index]["photoURL"]),
                        ),
                        SizedBox(height: 6.0),
                        Text(
                          favorites[index]["displayName"].split("@")[0],
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
