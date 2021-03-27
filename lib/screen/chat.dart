import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:voice_chat/colors.dart';
import 'package:voice_chat/model/message.dart';
import 'package:voice_chat/ui_constants.dart';
import 'package:voice_chat/widget/bottom_chat_area.dart';
import 'package:voice_chat/widget/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  var messages = [];
  FlutterSoundPlayer player = FlutterSoundPlayer();

  @override
  void initState() {
    player.openAudioSession().then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    player.closeAudioSession();
    player = null;
    super.dispose();
  }

  Future<void> playRecording(String uri) async {
    player.startPlayer(
      fromURI: uri,
      codec: Codec.aacADTS,
    );
  }

  Widget body(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      padding: allMargin8,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 90,
                color: Color.fromRGBO(34, 153, 99, 1),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 58.0),
                  child: ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final item = messages[index];
                        final prevItem = index > 0 ? messages[index - 1] : null;
                        final bool removeTopMargin =
                            index > 0 && (item.toSender == prevItem.toSender);
                        final double twentyPercent =
                            MediaQuery.of(context).size.width * 0.2;
                        return Container(
                            margin: EdgeInsets.only(
                                left: item.toSender ? 10.0 : twentyPercent,
                                right: item.toSender ? twentyPercent : 10.0,
                                bottom: removeTopMargin ? 0.0 : 5.0,
                                top: 5.0),
                            padding: EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8.0, bottom: 2.0),
                            width: 100.0,
                            decoration: BoxDecoration(
                                color: item.toSender
                                    ? Colors.white
                                    : Color.fromRGBO(220, 248, 200, 1),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(51, 51, 51, 0.6),
                                      blurRadius: 0.0,
                                      offset: Offset(0, 0))
                                ]),
                            child: Column(
                              mainAxisAlignment: item.toSender
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      MessageBubble(
                                        onClick:
                                            (AnimationController controller) {
                                          player.startPlayer(
                                              fromURI: item.path,
                                              codec: Codec.aacADTS,
                                              whenFinished: () =>
                                                  controller.reverse());
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      item.timestamp,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                    !item.toSender
                                        ? Icon(Icons.done_all,
                                            size: 16, color: Colors.grey)
                                        : Container(),
                                  ],
                                )
                              ],
                            ));
                      }),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: BottomChatArea(
              width: width,
              height: height,
              onAudioSend: (String path) {
                setState(() {
                  messages.add(
                    Message(
                        path: path,
                        toSender: false,
                        timestamp: "${DateTime.now().millisecondsSinceEpoch}"),
                  );
                });
              },
              onAudioCancel: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget appbar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: green_color,
      title: Text(
        "Voice Chat",
        style: TextStyle(color: white_color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardSizeProvider(
      smallSize: 800.0,
      child: Scaffold(
        backgroundColor: lightGrey_color,
        appBar: appbar(context),
        body: body(context),
      ),
    );
  }
}
