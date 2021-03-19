import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_ui/utils/make_a_chat.dart';

class Contacts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        return ContactsWidget(user: snapshot);
      },
    );
  }
}

// ignore: must_be_immutable
class ContactsWidget extends StatefulWidget {
  var user;
  ContactsWidget({Key key, this.user}) : super(key: key);

  @override
  _ContactsWidgetState createState() => _ContactsWidgetState();
}

class _ContactsWidgetState extends State<ContactsWidget> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    var usersWithMe = widget.user.data.docs.map((doc) => doc.data()).toList();
    var users =
        usersWithMe.where((i) => i["uid"] != auth.currentUser.uid).toList();

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
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              print(index);
              return GestureDetector(
                onTap: () {
                  // create_a_chat(auth.currentUser.uid, users[index]["uid"]);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(contact: users[index]),
                    ),
                  );
                },
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
                                NetworkImage(users[index]["photoURL"]),
                          ),
                          SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                users[index]["displayName"],
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
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
