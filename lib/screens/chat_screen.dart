import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/utils/make_a_chat.dart';
import 'package:flutter_chat_ui/utils/send_a_chat.dart';
// import 'package:flutter_chat_ui/models/message_model.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  Map<String, dynamic> contact;
  String chatRoomId;
  ChatScreen({Key key, this.contact, this.chatRoomId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    User firebaseUser = FirebaseAuth.instance.currentUser;
    Query chats;

    String meId = firebaseUser.uid;
    String contactId = widget.contact["uid"];

    if (widget.chatRoomId != null) {
      chats = FirebaseFirestore.instance
          .collection('Chats')
          .where("chatRoomId", isEqualTo: widget.chatRoomId);
    }
    chats = FirebaseFirestore.instance
        .collection('Chats')
        .where("contacts.$contactId", isEqualTo: true)
        .where("contacts.$meId", isEqualTo: true);

    print(chats);
    //Can't do multiple where filter

    return StreamBuilder<QuerySnapshot>(
      stream: chats.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        return ChatScreenWidget(chats: snapshot, contact: widget.contact);
      },
    );
  }
}

// ignore: must_be_immutable
class ChatScreenWidget extends StatefulWidget {
  AsyncSnapshot<QuerySnapshot> chats;
  Map<String, dynamic> contact;

  ChatScreenWidget({this.chats, this.contact});

  @override
  _ChatScreenWidgetState createState() => _ChatScreenWidgetState();
}

class _ChatScreenWidgetState extends State<ChatScreenWidget> {
  _buildMessage(message, bool isMe) {
    final Container msg = Container(
      margin: isMe
          ? EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 80.0,
            )
          : EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: isMe ? Theme.of(context).accentColor : Color(0xFFFFEFEE),
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message["sentTime"]
                    .toDate()
                    .difference(DateTime.now())
                    .inDays
                    .toString() +
                " days ago",
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            message["msg"],
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
    if (isMe) {
      return msg;
    }
    return Row(
      children: <Widget>[
        msg,
      ],
    );
  }

  _buildMessageComposer(meId, chats) {
    String msg;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              onChanged: (String text) {
                print("$text");
                msg = text;
              },
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              if (chats == null) {
                send_a_chat(meId, msg, widget.contact["uid"]);
              } else {
                send_a_chat(
                    meId, msg, widget.contact["uid"], chats["chatRoomdId"]);
              }
            },
            //to do add functionality to add chat
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    var chats = [];
    chats = widget.chats.data.docs.map((element) => element.data()).toList();
    chats = chats[0]["chats"];
    chats.sort((a, b) => a["sentTime"].compareTo(b["sentTime"]));

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.contact["photoURL"]),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.contact["displayName"],
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
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
                    reverse: false,
                    padding: EdgeInsets.only(top: 15.0),
                    itemCount: chats.length,
                    itemBuilder: (BuildContext context, int index) {
                      final chat = chats[index];
                      final bool isMe =
                          chat["sender"]["uid"] == auth.currentUser.uid;
                      return _buildMessage(chat, isMe);
                    },
                  ),
                ),
              ),
            ),
            _buildMessageComposer(auth.currentUser.uid, chats),
          ],
        ),
      ),
    );
  }
}
