import 'dart:math';

import 'package:flutter/material.dart';
import 'package:voice_chat/colors.dart';
import 'package:voice_chat/ui_constants.dart';
import 'package:voice_chat/widget/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  bool accepted = false;
  bool onPress = false;

  double _width = 50.0;
  double _height = 50.0;
  bool _visible = true;

  AnimationController _animationController;

  Animation<double> _micTranslateTop;
  Animation<double> _micRotationFirst;
  Animation<double> _micTranslateRight;
  Animation<double> _micTranslateLeft;
  Animation<double> _micRotationSecond;
  Animation<double> _micTranslateDown;
  Animation<double> _micInsideTrashTranslateDown;

  Animation<double> _trashWithCoverTranslateTop;
  Animation<double> _trashCoverRotationFirst;
  Animation<double> _trashCoverTranslateLeft;
  Animation<double> _trashCoverRotationSecond;
  Animation<double> _trashCoverTranslateRight;
  Animation<double> _trashWithCoverTranslateDown;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2500),
    );

    _micTranslateTop = Tween(begin: 0.0, end: -150.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    _micRotationFirst = Tween(begin: 0.0, end: pi).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.2),
      ),
    );

    _micTranslateRight = Tween(begin: 0.0, end: 13.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.1),
      ),
    );

    _micTranslateLeft = Tween(begin: 0.0, end: -13.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.1, 0.2),
      ),
    );

    _micRotationSecond = Tween(begin: 0.0, end: pi).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 0.45),
      ),
    );

    _micTranslateDown = Tween(begin: 0.0, end: 150.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.45, 0.79, curve: Curves.easeInOut),
      ),
    );

    _micInsideTrashTranslateDown = Tween(begin: 0.0, end: 55.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.95, 1.0, curve: Curves.easeInOut),
      ),
    );

    _trashWithCoverTranslateTop = Tween(begin: 30.0, end: -25.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.45, 0.6),
      ),
    );

    _trashCoverRotationFirst = Tween(begin: 0.0, end: -pi / 3).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.6, 0.7),
      ),
    );

    _trashCoverTranslateLeft = Tween(begin: 0.0, end: -18.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.6, 0.7),
      ),
    );

    _trashCoverRotationSecond = Tween(begin: 0.0, end: pi / 3).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.8, 0.9),
      ),
    );

    _trashCoverTranslateRight = Tween(begin: 0.0, end: 18.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.8, 0.9),
      ),
    );

    _trashWithCoverTranslateDown = Tween(begin: 0.0, end: 55.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.95, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  _chatTextArea() {
    return Expanded(
      child: TextFormField(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          filled: true,
          fillColor: Colors.white,
          //contentPadding: EdgeInsets.all(10),
          hintText: onPress == false
              ? "Type a message"
              : "          0.00                              < Slide to Cancel",
          // prefixIcon: onPress == false ? Icon(null) : IconButton(icon: Icon(Icons.mic, color: Colors.red[600],), onPressed: (){},),
          //suffix: onPress == false ? Text("") : Text("< Slide to Cancel", style: TextStyle(color: Colors.black.withOpacity(0.5)),)
        ),
      ),
      //onPress == false? Container() :animatedMic()
    );
  }

  Widget animatedMic() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform(
                  transform: Matrix4.identity()
                    ..translate(0.0, 24)
                    ..translate(_micTranslateRight.value)
                    ..translate(_micTranslateLeft.value)
                    ..translate(0.0, _micTranslateTop.value)
                    ..translate(0.0, _micTranslateDown.value)
                    ..translate(0.0, _micInsideTrashTranslateDown.value),
                  child: Transform.rotate(
                    angle: _micRotationFirst.value,
                    child: Transform.rotate(
                      angle: _micRotationSecond.value,
                      child: child,
                    ),
                  ),
                );
              },
              child: IconButton(
                icon: Icon(
                  Icons.mic,
                  color: Color(0xFFef5552),
                  size: 30,
                ),
                onPressed: () {
                  _animationController.forward();
                },
              ),
            ),
            AnimatedBuilder(
                animation: _trashWithCoverTranslateTop,
                builder: (context, child) {
                  return Transform(
                    transform: Matrix4.identity()
                      ..translate(0.0, _trashWithCoverTranslateTop.value)
                      ..translate(0.0, _trashWithCoverTranslateDown.value),
                    child: child,
                  );
                },
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _trashCoverRotationFirst,
                      builder: (context, child) {
                        return Transform(
                          transform: Matrix4.identity()
                            ..translate(_trashCoverTranslateLeft.value)
                            ..translate(_trashCoverTranslateRight.value),
                          child: Transform.rotate(
                            angle: _trashCoverRotationSecond.value,
                            child: Transform.rotate(
                              angle: _trashCoverRotationFirst.value,
                              child: child,
                            ),
                          ),
                        );
                      },
                      child: Image(
                        image: AssetImage('assets/trash_cover.png'),
                        width: 30,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 1.5),
                      child: Image(
                        image: AssetImage('assets/trash_container.png'),
                        width: 30,
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget voiceChatButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: voiceButtonPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _animationController.forward();
              },
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

  _micIcon() {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          onPress = true;
        });
      },
      child: Draggable(
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            int sensitivity = 4;
            if (details.delta.dx < -sensitivity) {
              _animationController.forward();
              Future.delayed(const Duration(seconds: 3), () {
                onPress = false;
                setState(() {});
              });
            }
          },
          onVerticalDragUpdate: (details) {
            int sensitivity = 4;
            if (details.delta.dy < -sensitivity) {
              setState(() {
                if (_width == 50) {
                  _width = 40;
                } else if (_width == 40) {
                  _width = 30;
                } else if (_width == 30) {
                  _width = 20;
                } else if (_width == 20) {
                  _width = 10;
                } else if (_width == 10) {
                  _width = 0;
                } else if (_width == 0) {
                  _visible = !_visible;
                }
              });
            }
          },
          child: AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: AnimatedContainer(
              width: _width,
              height: _height,
              duration: Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              margin: EdgeInsets.only(left: 6.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.teal[700]),
              child: Center(
                child: Icon(
                  Icons.mic,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        feedback: Container(
          width: 60,
          height: 160,
          child: Stack(
            children: [
              Container(
                height: 120,
                width: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.lock),
                  ),
                ),
              ),
              Positioned(
                top: 100.0,
                child: animatedContainer(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget animatedContainer() {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: AnimatedContainer(
        width: _width,
        height: _height,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
        margin: EdgeInsets.only(left: 6.0),
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: Colors.teal[700]),
        child: Center(
          child: Icon(
            Icons.mic,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  _bottomChatArea() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 160,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [_chatTextArea(), _micIcon()],
        ),
      ),
    );
  }

  Widget body(BuildContext context) {
    return Container(
        padding: allMargin8,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            _bottomChatArea(),
            onPress == false ? Container() : animatedMic()
          ],
        ));
  }

  Widget appbar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: Colors.teal[700],
      title: Text(
        "Santhosh",
        style: TextStyle(color: white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: appbar(context),
      body: body(context),
    );
  }
}
