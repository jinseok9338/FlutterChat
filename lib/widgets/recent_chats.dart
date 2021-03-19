import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_chat_ui/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecentChats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    Query user = FirebaseFirestore.instance
        .collection('Users')
        .where("uid", isEqualTo: _auth.currentUser.uid);

    return StreamBuilder<QuerySnapshot>(
      stream: user.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        return RecentChatsClass(snapshot: snapshot);
      },
    );
  }
}

// ignore: must_be_immutable
class RecentChatsClass extends StatefulWidget {
  AsyncSnapshot<QuerySnapshot> snapshot;
  RecentChatsClass({Key key, this.snapshot}) : super(key: key);

  @override
  _RecentChatsState createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChatsClass> {
  @override
  Widget build(BuildContext context) {
    var user = widget.snapshot.data.docs.map((doc) => doc.data()).toList()[0];
    var chatRooms = user["chatRooms"];

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (BuildContext context, int index) {
              final chatRoom = chatRooms[index];
              print(chatRoom);

              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      contact: chatRoom["contact"],
                      chatRoomId: chatRoom["chatRoomId"],
                      //This is wrong because it only
                    ),
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 35.0,
                            backgroundImage:
                                NetworkImage(chatRoom["contact"]["photoURL"]),
                          ),
                          SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                chatRoom["contact"]["displayName"],
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: Text(
                                  chatRoom["lastMessage"],
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            chatRoom["lastSentTime"]
                                    .toDate()
                                    .difference(DateTime.now())
                                    .inDays
                                    .toString() +
                                "days ago",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.0),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
