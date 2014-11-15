library example.isolate.main;

import 'dart:isolate';
import 'dart:async';

var sendPort;

void main() {
  
  var receivePort = new ReceivePort();
  receivePort.listen((msg) {
    if (sendPort == null) {
      sendPort = msg as SendPort;
      ready();
    } else print("got msg $msg");
  });
  
  Isolate.spawnUri(Uri.parse('isolate.dart'), [], receivePort.sendPort);
  
}

void ready() {
  
  sendPort.send("test 1");
  sendPort.send("send 2");
  
  new Timer(const Duration(seconds: 1), () {
    sendPort.send("send 3");
  });
  
}
