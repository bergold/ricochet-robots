library ricochetrobots_backend.gameconnector;

import 'dart:async';
import 'dart:isolate';
import 'dart:math';

import 'package:ricochetrobots/messages.dart';

const String _isolatePath = 'game.isolate.dart';

/// Generates a random String with the [length] defaults to 5.
String generateGameID([length = 5]) {
  var chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVW'.split('');
  var rnd = new Random();
  var out = new StringBuffer();
  for (var i = 0; i < length; i++) {
    out.write(chars.elementAt(rnd.nextInt(chars.length)));
  }
  return out.toString();
}

class GameConnector {
  
  /// Holds all games with its gameId.
  Map _games = new Map<String, GameBridge>();
  
  /// This stream receives messages from websockets.
  StreamController _input = new StreamController();
  /// This stream is used to send messages back to the websocket.
  StreamController _output = new StreamController();
  
  GameConnector() {
    
    _input.stream.listen((msg) {
      if (msg is GameCreateRequestMessage) {
        
        create(msg);
        
      } else {
        
        if (!msg.has('gameId')) throw new ArgumentError('The field gameId is required.');
        var game = find(msg.gameId);
        if (game == null) throw new ArgumentError('The game ${msg.gameId} does not exists.');
        game.send(msg);
        
      }
    });
    
  }
  
  create(GameCreateRequestMessage msg) {
    
  }
  
  find(String gameId) {
    return _games[gameId];
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
