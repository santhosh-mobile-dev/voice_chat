import 'package:flutter/material.dart';
import 'package:voice_chat/ui_constants.dart';
import 'package:voice_chat/widget/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Widget voiceChatButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: voiceButtonPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.mic,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget view(BuildContext context) {
    return Container(
      margin: allMargin8,
      child: Stack(
        children: <Widget>[
          ListView(
            children: [
              MessageBubble(),
            ],
          ),
          voiceChatButton(context),
        ],
      ),
    );
  }

  Widget get appBarTitle => Text("Voice Chat");

  Widget appBar(BuildContext context) {
    return AppBar(
      title: appBarTitle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: view(context),
    );
  }
}
