
```dart
void mainLoop(SendPort sendPort) async {
	while(true){
	sendPort.send(true);
	}
}

import 'dart:isolate';
import 'package:flutter/material.dart';

class Isolate extends StatefulWidget {
  @override
  _IsolateState createState() => _IsolateState();
}

class _IsolateState extends State<Isolate> {
  bool isFirstStartGame = true;
  double x = 150;
  ReceivePort _receivePort;
  Isolate _isolateLoop;

  void startIsolateLoop() async {
    _receivePort = ReceivePort();
	_isolateLoop = await Isolate.spawn(mainLoop, _receivePort.sendPort);
    _receivePort.listen((message) {
      setState(() {});
      x++;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isFirstStartGame) {
      startIsolateLoop();   
//если это первый запуск то запускаем изолят который будет 60 раз в секунду перерисовывать экран и менять значение X
      isFirstStartGame = false;
    }
    return Stack(
      children: [
        Positioned(top: y, left: x, child: Text("fdsdfsdf")),
      ],
    );
  }
}
```
