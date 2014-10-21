library ricochetrobots_backend.gameconnector;

import 'dart:async';
import 'dart:isolate';

const String _isolatePath = 'game.isolate.dart';

class GameConnector {
  
  /// This stream receives messages from websockets.
  StreamController _input = new StreamController();
  /// This stream is used to send messages back to the websocket.
  StreamController _output = new StreamController();
  
  GameConnector() {
    
    _input.stream.listen((data) {
      // [Todo] Send this data to the correct game or create a new if it's the cmd.
    });
    
  }
  
  StreamConsumer get input => _input;
  Stream get output => _output.stream;
  
}

class GameBridge {
  
  final SendPort _input;
  final ReceivePort _output;
  
  static Future create() {
    var spawned = new Completer();
    var sendPort;
    var receivePort = new ReceivePort();
    receivePort.listen((msg) {
      if (sendPort == null) {
        sendPort = msg as SendPort;
        spawned.complete(new GameBridge.fromIsolate(receivePort, sendPort));
      }
    });
    Isolate.spawnUri(Uri.parse(_isolatePath), [], receivePort.sendPort);
    return spawned.future;
  }
  
  GameBridge.fromIsolate(this._output, this._input) {
    _output.listen((data) {
      // [Todo] Got data from isolate.
    });
  }
  
  void send(msg) {
    
  }
  
}
