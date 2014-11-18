library ricochetrobots_backend.socketconnector;

import 'dart:async';

import 'package:uuid/uuid.dart';
import 'package:ricochetrobots/messages.dart';
import 'package:ricochetrobots/analytics.dart' as Analytics;

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
    _listen(ws, clientId);
  }
  
  void _listen(ws, clientId) {
    ws.map((string) => new MessageBase.fromJson(string, asString: true)).listen((msg) {
      
      if (msg is ReconnectRequestMessage) {
        // [Todo] Handle reconect.
        throw new UnimplementedError('Reconnect is not yet implemented.');
      } else {
        _output.add(msg);
      }
      
    }, onError: (error, stacktrace) {
      if (error is FormatException) {
        var msgString = 'Json parsing error in \'${error.source}\': ${error.message}';
        _sendFormatException(clientId, msgString);
        print(msgString);
      } else if (error is ArgumentError) {
        _sendArgumentError(clientId, error);
        print('ArgumentError: ${error.message}');
      } else if (error is UnsupportedError) {
        _sendUnsupportedError(clientId, error);
        print('UnsupportedError: $error');
      } else {
        print('WebSocketStreamError: [$error]');
        print(stacktrace);
      }
    }, onDone: () {
      // [Todo] Connection closed.
      print("Connection closed");
      Analytics.trigger('connection.close');
    });
  }
  
  /// This function sends a [ConnectResponseMessage] to the clientId.
  _connectSuccess(String clientId) {
    var msg = new ConnectResponseMessage(clientId);
    send(msg);
    
    Analytics.trigger('connection.open');
  }
  
  /// Sends a [FormatException] to the client.
  _sendFormatException(String clientId, String msg) {
    send(new FormatErrorMessage(clientId, {
      'message': msg
    }));
  }
  
  /// Sends a [ArgumentError] to the client.
  _sendArgumentError(String clientId, ArgumentError error) {
    send(new ArgumentErrorMessage(clientId, {
      'message': error.message
    }));
  }

  /// Sends a [UnsupportedError] to the client.
  _sendUnsupportedError(String clientId, UnsupportedError error) {
    send(new UnsupportedErrorMessage(clientId, {
      'message': error.toString()
    }));
  }
  
  /// This function parses the [msg] into Json
  /// and sends it to the WebSocket that is connected to the clientId named in the [Message].
  /// 
  /// It returns false the connection could not be found or if the WebSocket is not opened
  /// otherwise it returns true.
  send(MessageBase msg) {
    var ws = _connections[msg.clientId];
    if (ws == null || ws.closeCode != null) return false;
    ws.add(msg.toJson(asString: true));
    return true;
  }
  
  StreamConsumer get input => _input;
  Stream get output => _output.stream;
  
}
