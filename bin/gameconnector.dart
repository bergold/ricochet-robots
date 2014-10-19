library ricochetrobots_backend.gameconnector;

import 'dart:async';

class GameConnector {
  
  static const String _isolatePath = 'game.isolate.dart';
  
  /// This stream receives messages from websockets.
  StreamController _input = new StreamController();
  /// This stream is used to send messages back to the websocket.
  StreamController _output = new StreamController();
  
  /// Transformes the StreamController to a StreamConsumer.
  StreamConsumer get input => _input;
  Stream get output => _output.stream;
  
}
