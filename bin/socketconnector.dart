library ricochetrobots_backend.socketconnector;

import 'dart:async';
import 'dart:convert';

import 'package:uuid/uuid.dart';

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
    ws.map((string) => JSON.decode(string)).listen((data) {
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
  
  void send(String clientId, Object msg) {
    
  }
  
  StreamConsumer get input => _input;
  Stream get output => _output.stream;
  
}
