import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Widget view(BuildContext context) {
    return Container();
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
