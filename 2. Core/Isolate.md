
Приложение Dart работает в **однопоточном** режиме, это не означает, что нельзя использовать другие потоки. Созданный изолят будет иметь свою **собственную память** и **собственный поток**, который будет работать в другом потоке параллельно основному потоку приложения. Два изолята не имеют доступа к памяти друг друга и могут взаимодействовать только посредством сообщений.

#### Применение
Создание изолятов обычно применяется для вынесения в отдельный поток вычиcлений, которые могут занять продолжительное время. 

#### Наш случай
Пример для игры, (обновление экрана 60 раз в секунду). Отдельный изолят будет оповещать основной, что нужно обновить экран, чтобы основной изолят не останавливался из за бесконечного лупа.

При создании нового изолята ему предоставляется объект, который называется send port и который применяется для отправки сообщений. 
  ```dart
ReceivePort _receivePort;
Isolate _isolateLoop;

_receivePort = ReceivePort();
_isolateLoop = await Isolate.spawn(mainLoop, _receivePort.sendPort);
```

Далее создаем метод `isolateLoop` который будет работать в отдельном потоке
и по полученному `sendPort` отправлять слушателю
```dart
void isolateLoop(SendPort sendPort) async {
	while(true){
	sendPort.send(true);
	}
}
```

На изоляте главного потока для получения сообщений можно использовать объект `receive port`.
 ```dart
_receivePort.listen((message) {
     //здесь можем обрабатывать полученную информацию из другого изолята
    });
```

Когда изолят закончил свою работу его можно завершить
 ```dart
receivePort.close();
isolate.kill();
```

### Полный код

```dart
void isolateLoop(SendPort sendPort) async {
	while(true){
	sendPort.send(true);
	}
}
```

```dart
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

  void startIsolateLoop() async { // Метод который запускает изолят
    _receivePort = ReceivePort();
	_isolateLoop = await Isolate.spawn(isolateLoop, _receivePort.sendPort);
	//Затем для прослушивания входящих сообщений запускаем метод listen():
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
