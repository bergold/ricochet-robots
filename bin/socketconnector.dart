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
    
    _input.stream.listen((msg) => send(msg));
    
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
    _connectSuccess(clientId);
    _listen(ws);
  }
  
  void _listen(ws) {
    ws.map((string) => new Message.fromJson(string, asString: true)).listen((msg) {
      
      if (msg is ReconnectRequestMessage) {
        // [Todo] Handle reconect.
        throw new UnimplementedError('Reconnect is not yet implemented.');
      } else {
        _output.add(msg);
      }
      
    }, onError: (error, stacktrace) {
      if (error is FormatException) {
        // [Todo] Got invalid json. Report back to client.
        print('Json parsing error in \'${error.source}\': ${error.message}');
      } else if (error is ArgumentError) {
        // [Todo] Got invalid arguments in json (missing fields). Report back to client.
        print('ArgumentError: ${error.message}');
      } else {
        print('WebSocketStreamError [$error] with stacktrace: $stacktrace');
      }
    }, onDone: () {
      // [Todo] Connection closed.
      print("Connection closed");
    });
  }
  
  /// This function sends a [ConnectResponseMessage] to the clientId.
  _connectSuccess(String clientId) {
    var msg = new ConnectResponseMessage(clientId);
    send(msg);
  }
  
  /// This function parses the [msg] into Json
  /// and sends it to the WebSocket that is connected to the clientId named in the [Message].
  /// 
  /// It returns false the connection could not be found or if the WebSocket is not opened
  /// otherwise it returns true.
  send(Message msg) {
    var ws = _connections[msg.clientId];
    if (ws == null || ws.closeCode != null) return false;
    ws.add(msg.toJson(asString: true));
    return true;
  }
  
  StreamConsumer get input => _input;
  Stream get output => _output.stream;
  
}
