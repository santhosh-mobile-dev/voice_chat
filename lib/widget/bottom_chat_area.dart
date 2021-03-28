import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:flutter_keyboard_size/screen_height.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:voice_chat/colors.dart';

typedef fun = void Function();

class BottomChatArea extends StatefulWidget {
  final double width;
  final double height;
  final Function(String) onAudioSend;
  final Function() onAudioCancel;

  const BottomChatArea(
      {Key key,
      @required this.width,
      @required this.height,
      @required this.onAudioSend,
      @required this.onAudioCancel})
      : super(key: key);

  @override
  _BottomChatAreaState createState() => _BottomChatAreaState();
}

class _BottomChatAreaState extends State<BottomChatArea>
    with TickerProviderStateMixin {
  AnimationController _recordController;
  AnimationController _animationController;
  Animation _animation;
  bool flag = true;
  bool onPress = false;
  Stream<int> timerStream;
  StreamSubscription<int> timerSubscription;
  String minutesStr = '00';
  String secondsStr = '00';
  Offset position;
  bool isRecording = false;
  bool longRecording = false;
  double _size = 50.0;
  bool expand = false;
  double oldX = 0;
  double oldY = 0;
  bool shouldActivate = false;
  int tcount = 10;
  var xs = Set();
  var ys = Set();
  int direction = -1;
  double marginBack = 38.0;
  double marginText = 36.0;
  int scount = 0;
  double vheight = 200.0;
  bool showLockUi = false;
  bool shouldSend = true;

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

  // Audio
  FlutterSoundRecorder _myRecorder = FlutterSoundRecorder();
  bool _mRecorderIsInited = false;
  String filePath = "";

  @override
  void initState() {
    _recordController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _recordController.repeat(reverse: true);

    _animation = Tween(begin: 1.0, end: 0.0).animate(_recordController)
      ..addListener(() {
        setState(() {});
      });

    this.position = Offset(widget.width - 60, widget.height - 54);
    this.oldX = widget.width - 60;
    this.oldY = widget.height - 54;

    // Audio settings
    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });

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

    _micInsideTrashTranslateDown = Tween(begin: 0.0, end: 75.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.95, 1.0, curve: Curves.easeInOut),
      ),
    );

    _trashWithCoverTranslateTop = Tween(begin: 50.0, end: -18.0).animate(
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

    _trashWithCoverTranslateDown = Tween(begin: 0.0, end: 75.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.95, 1.0, curve: Curves.easeInOut),
      ),
    );

    super.initState();
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _myRecorder.openAudioSession();
    _mRecorderIsInited = true;
  }

  void _updateSize() {
    setState(() {
      _size = expand ? 50.0 : 80.0;
      position = expand ? Offset(oldX, oldY) : Offset(oldX - 15, oldY - 15);
      expand = !expand;
      shouldActivate = !shouldActivate;
    });
  }

  @override
  void dispose() {
    this._recordController = null;
    _myRecorder.closeAudioSession();
    _myRecorder = null;
    super.dispose();
  }

  Future<void> record() async {
    if (_mRecorderIsInited) {
      var tempDir = await getTemporaryDirectory();
      String path =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.aac';
      await _myRecorder.startRecorder(
        toFile: path,
        codec: Codec.aacADTS,
      );
      setState(() {});
    } else {
      print("Recorder not initiated");
    }
  }

  Future<void> stopRecorder() async {
    String url = await _myRecorder.stopRecorder();
    setState(() {
      filePath = url;
    });
    if (shouldSend) widget.onAudioSend(filePath);
  }

  fun getRecorderFn() {
    if (!_mRecorderIsInited) {
      return null;
    }
    return _myRecorder.isStopped ? record : stopRecorder;
  }

  Stream<int> stopWatchStream() {
    StreamController<int> streamController;
    Timer timer;
    Duration timerInterval = Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
        counter = 0;
        streamController.close();
      }
    }

    void tick(_) {
      counter++;
      streamController.add(counter);
      if (!flag) {
        stopTimer();
      }
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
  }

  Widget audioBox() {
    return Container(
      margin: EdgeInsets.only(right: marginBack, left: 8.0, bottom: 4.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(51, 51, 51, 0.6),
                blurRadius: 0.0,
                offset: Offset(0, 0))
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedOpacity(
            opacity: _animation.value,
            duration: Duration(milliseconds: 100),
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Icon(Icons.mic, color: Colors.red)),
                    onTap: () {})),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 48,
              alignment: Alignment.centerLeft,
              child: Text("$minutesStr:$secondsStr"),
            ),
          ),
          longRecording
              ? GestureDetector(
                  onTap: () {
                    if (_myRecorder.isRecording) {
                      setState(() {
                        shouldSend = false;
                        longRecording = false;
                      });
                      stopRecorder();
                    }
                    _resetUi();
                    _resetTimer();
                  },
                  child: Text("Cancel", textAlign: TextAlign.center))
              : Shimmer.fromColors(
                  direction: ShimmerDirection.rtl,
                  child: Text(
                    "Swipe to cancel",
                    textAlign: TextAlign.center,
                  ),
                  baseColor: Colors.red,
                  highlightColor: Colors.yellow),
          SizedBox(width: marginText),
        ],
      ),
    );
  }

  void _resetTimer() {
    if (!longRecording) {
      timerSubscription.cancel();
      timerStream = null;
      setState(() {
        minutesStr = '00';
        secondsStr = '00';
      });
    }
  }

  void _resetUi() {
    //_resetTimer();
    setState(() {
      xs.clear();
      ys.clear();
      tcount = 10;
      isRecording = longRecording ? true : false;
      marginBack = longRecording ? 64.0 : 38.0;
      marginText = longRecording ? 16 : 36.0;
      scount = 0;
      position = Offset(oldX, oldY);
      showLockUi = false;
      vheight = 200;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () {},
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

    return Consumer<ScreenHeight>(
      builder: (context, _res, child) => Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: isRecording
                ? audioBox()
                : onPress
                    ? animatedMic()
                    : Container(),
          ),
          showLockUi
              ? Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: vheight,
                    width: 54,
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50)),
                        color: Colors.black38),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.lock, color: Colors.white)),
                  ),
                )
              : Container(),
          Positioned(
            right: 2.0,
            bottom: 2.0,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (longRecording) {
                  setState(() {
                    shouldSend = true;
                    longRecording = false;
                  });
                  if (_myRecorder.isRecording) stopRecorder();
                  _resetUi();
                  _resetTimer();
                }
              },
              onLongPressStart: (_) {
                HapticFeedback.mediumImpact();
                _updateSize();
                setState(() {
                  isRecording = true;
                });
                if (_myRecorder.isStopped) {
                  record();
                }
                timerStream = stopWatchStream();
                timerSubscription = timerStream.listen((int newTick) {
                  setState(() {
                    minutesStr = ((newTick / 60) % 60)
                        .floor()
                        .toString()
                        .padLeft(2, '0');
                    secondsStr =
                        (newTick % 60).floor().toString().padLeft(2, '0');
                    if (secondsStr == '03') showLockUi = true;
                  });
                });
              },
              onLongPressEnd: (_) {
                HapticFeedback.lightImpact();
                _updateSize();
                if (_myRecorder.isRecording && !longRecording) {
                  setState(() {
                    shouldSend = true;
                  });
                  stopRecorder();
                }
                _resetUi();
                _resetTimer();
              },
              onLongPressMoveUpdate: (mu) {
                setState(() {
                  if (tcount == 0) {
                    if (xs.length > ys.length) {
                      direction = 1;
                    } else if (xs.length < ys.length) {
                      direction = 2;
                    } else {
                      direction = -1;
                    }
                  } else {
                    tcount -= 1;
                    xs.add(mu.globalPosition.dx);
                    ys.add(mu.globalPosition.dy);
                  }
                });
                if (direction == 1) {
                  position = Offset(mu.globalPosition.dx - 50, oldY - 16);
                  setState(() {
                    scount += 1;
                    if (scount == 10) {
                      marginBack += 5;
                      if (marginText < 50) marginText += 2;
                      scount = 0;
                    }
                  });
                } else if (direction == 2) {
                  position = Offset(oldX - 10, mu.globalPosition.dy - 50);
                  setState(() {
                    scount += 1;
                    if (scount == 10) {
                      vheight -= 8;
                      scount = 0;
                    }
                  });
                }
                if (mu.globalPosition.dy < widget.height - 150) {
                  // Threshold reached
                  setState(() {
                    longRecording = true;
                    position = Offset(oldX, oldY);
                    marginBack = 64.0;
                    direction = -1;
                    showLockUi = false;
                    //shouldSend = true;
                  });
                }
                if (mu.globalPosition.dx - 50 < 220) {
                  setState(() {
                    shouldSend = false;
                    onPress = true;
                  });
                  if (_myRecorder.isRecording) stopRecorder();
                  _animationController.forward();
                  _resetUi();
                  _resetTimer();
                }
              },
              child: Container(
                child: Material(
                  color: green_color,
                  borderRadius: BorderRadius.circular(100),
                  child: AnimatedSize(
                    curve: Curves.easeIn,
                    vsync: this,
                    duration: const Duration(milliseconds: 100),
                    child: InkWell(
                      child: Container(
                        width: _size,
                        height: _size,
                        child: Icon(longRecording ? Icons.send : Icons.mic,
                            color: yellow_color),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
