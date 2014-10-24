library ricochetrobots_backend.socketconnector;

import 'dart:async';

import 'package:uuid/uuid.dart';
import 'package:ricochetrobots/messages.dart';

class SocketConnector {
  
  /// Maps all websocket connections to a unique clientId.
  Map _connections = new Map();
  /// Streams all messages received by any open websocket.
  StreamController _output = new StreamController();
  /// Send the events received on this Stream to the correct websocket.
  StreamController _input = new StreamController();
  
  SocketConnector() {
    
    _input.stream.listen((data) {
      // [Todo] Send this data to the correct websocket.
    });
    
  }
  
  /// Adds a new connection and assignes a new clientId. 
  void handle(ws) {
    var uuid = new Uuid();
    var clientId;
    do {
      clientId = uuid.v4();
    } while (_connections.containsKey(clientId));
    _connections[clientId] = ws;
    print('New client connected with $clientId');
    // [Todo] Create msg with clientId and send back.
    _listen(ws);
  }
  
  void _listen(ws) {
    ws.map((string) => new Message.fromJson(string, asString: true)).listen((data) {
      // [Todo] Got valid json filter requests that aren't processed by GameConnector like reconnect here.
      _output.add(data);
    }, onError: (error, stacktrace) {
      // [Todo] Error received. Probably, invalid json.
      print('WebSocketStreamError [$error] with stacktrace: $stacktrace');
    }, onDone: () {
      // [Todo] Connection closed.
      print("Connection closed");
    });
  }
  
  /// This function parses the [msg] into Json
  /// and sends it to the WebSocket that is connected to the clientId named in the [Message].
  /// 
  /// It returns false the connection could not be found or if the WebSocket is not opened
  /// otherwise it returns true.
  send(Message msg) {
    var ws = _connections[msg.clientId];
    if (ws == null || ws.closeCode == null) return false;
    ws.add(msg.toJson(asString: true));
    return true;
  }
  
  StreamConsumer get input => _input;
  Stream get output => _output.stream;
  
}
