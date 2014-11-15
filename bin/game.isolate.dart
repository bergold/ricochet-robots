library ricochetrobots_backend.gameisolate;

import 'dart:isolate';

import 'package:ricochetrobots/messages.dart';

void main(List<String> args, SendPort sendPort) {
  var receivePort = new ReceivePort();
  sendPort.send(receivePort.sendPort);
  
  var adminId = args[0];
  
  receivePort.listen((MessageBase msg) {
    // [Todo] got msg
    print("got msg");
  });
}
