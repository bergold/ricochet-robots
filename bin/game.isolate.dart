library ricochetrobots_backend.gameisolate;

import 'dart:isolate';

void main(List<String> args, SendPort sendPort) {
  var receivePort = new ReceivePort();
  sendPort.send(receivePort.sendPort);
  
  receivePort.listen((msg) {
    // [Todo] got msg
  });
}
