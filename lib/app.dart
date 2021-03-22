import 'package:flutter/material.dart';
import 'package:voice_chat/screen/chat.dart';
import 'package:voice_chat/theme.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Voice Chat",
      theme: appTheme,
      home: ChatScreen(),
    );
  }
}
