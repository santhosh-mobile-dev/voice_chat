import 'package:flutter/material.dart';
import 'package:voice_chat/colors.dart';
import 'package:voice_chat/ui_constants.dart';

class MessageBubble extends StatefulWidget {
  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: allPadding12,
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: messageBubbleRadius,
            color: grey,
          ),
          padding: allPadding16,
          child: Container(
            child: Row(
              children: [
                Icon(Icons.play_arrow),
                Slider(value: 0.0, min: 0.0, max: 2.0, onChanged: (val) {})
              ],
            ),
          ),
        ),
      ),
    );
  }
}
