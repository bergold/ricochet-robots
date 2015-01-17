library ricochetrobots_backend.gameisolate;

import 'dart:isolate';

import 'package:ricochetrobots/ricochetrobots.dart';
import 'package:ricochetrobots/messages.dart';

void main(List<String> args, SendPort sendPort) {
  var receivePort = new ReceivePort();
  sendPort.send(receivePort.sendPort);
  
  var adminId = args[0];
  
  var game = new Game(adminId);
  
  receivePort.listen((MessageBase msg) {
    game.sendMsg(msg);
  });
  
  game.onmessage = (MessageBase msg) {
    sendPort.send(msg);
  };
  
}
