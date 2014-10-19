library ricochetrobots_backend.socketconnector;

import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:uuid/uuid.dart';

class SocketConnector {
  
  /// Maps all websocket connections to a unique clientId.
  Map _connections = new Map<String, WebSocket>();
  /// Streams all messages received by any open websocket.
  StreamController _output = new StreamController();
  /// Send the events received on this Stream to the correct websocket.
  StreamController _input = new StreamController();
  
  /// Adds a new connection and assignes a new clientId. 
  void handle(WebSocket ws) {
    var uuid = new Uuid();
    var clientId;
    do {
      clientId = uuid.v4();
    } while (_connections.containsKey(clientId));
    _connections[clientId] = ws;
    // [Todo] Create msg with clientId and send back.
    _listen(ws);
  }
  
  void _listen(WebSocket ws) {
    ws.transform(new JsonDecoder()).listen((data) {
      // [Todo] Got valid json filter requests that aren't processed by GameConnector like reconnect here.
      _input.add(data);
    }, onError: (error, stacktrace) {
      // [Todo] Error received. Probably, invalid json.
      print('WebSocketStreamError [$error] with stacktrace: $stacktrace');
    }, onDone: () {
      // [Todo] Connection closed.
    });
  }
  
  void send(String clientId, Object msg) {
    
  }
  
  StreamConsumer get input => _input;
  Stream get output => _output.stream;
  
}
