library example.isolate.iso;

import 'dart:isolate';

var sendPort;

void main(List<String> args, SendPort s) {
  sendPort = s;
  var receivePort = new ReceivePort();
  sendPort.send(receivePort.sendPort);
  
  receivePort.listen((msg) {
    // [Todo] got msg
    print("got msg $msg");
    sendPort.send(msg);
  });
}
