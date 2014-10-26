library ricochetrobots_backend.gameconnector;

import 'dart:async';
import 'dart:isolate';
import 'dart:math';

import 'package:ricochetrobots/messages.dart';

const String _isolatePath = 'game.isolate.dart';

/// Generates a random String with the [length] defaults to 5.
String generateGameId([length = 5]) {
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
    var gameId;
    do {
      gameId = generateGameId();
    } while(_games.containsKey(gameId));
    
    return GameBridge.create([msg.clientId]).then((game) {
      _games[gameId] = game;
      _output.add(new GameCreateResponseMessage(msg.clientId, {
        'gameId': gameId
      }));
      print('New game $gameId created by ${msg.clientId}');
      game.output.listen((msg) {
        _output.add(msg);
      });
    });
  }
  
  find(String gameId) {
    return _games[gameId];
  }
  
  StreamConsumer get input => _input;
  Stream get output => _output.stream;
  
}

class GameBridge {
  
  final SendPort _input;
  final Stream _output;
  
  final StreamController _lineBack = new StreamController();
  Stream get output => _lineBack.stream;
  
  static Future create([List<String> args]) {
    args = args == null ? [] : args;
    var spawned = new Completer();
    var sendPort;
    var receivePort = new ReceivePort();
    var receiver = new StreamController();
    receivePort.listen((msg) {
      if (sendPort == null) {
        sendPort = msg as SendPort;
        spawned.complete(new GameBridge.fromIsolate(receiver.stream, sendPort));
      } else {
        receiver.add(msg);
      }
    });
    Isolate.spawnUri(Uri.parse(_isolatePath), args, receivePort.sendPort);
    return spawned.future;
  }
  
  GameBridge.fromIsolate(this._output, this._input) {
    _output.listen((msg) {
      _lineBack.add(msg);
    });
  }
  
  void send(msg) {
    _input.send(msg);
  }
  
}
