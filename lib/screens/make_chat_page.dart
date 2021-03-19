import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/widgets/contact.dart';


class MakeChatPage extends StatefulWidget {
  @override
  _MakeChatPageState createState() => _MakeChatPageState();
}

class _MakeChatPageState extends State<MakeChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "create a chat",
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
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
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Contacts(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
