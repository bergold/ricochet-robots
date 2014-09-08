
part of ricochet_robots_backend;


const String ISOLATE_PATH = 'game.isolate.dart';

/**
 * Generates a random String with the default length 5.
 */
String generateGameID([length = 5]) {
  var chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVW'.split('');
  var rnd = new Random();
  var out = new StringBuffer();
  for (var i = 0; i < length; i++) {
    out.write(chars.elementAt(rnd.nextInt(chars.length)));
  }
  return out.toString();
}


/**
 * Manages different games.
 */
class GServerManager {
  /// A list of the open games.
  List<GServer> _games = new List<GServer>();
  
  GServerManager();
  
  /**
   * Searches for a GServer with the given id.
   */
  GServer findServer(String gameid) {
    var match = _games.where((g) => g.id == gameid);
    return match.isEmpty ? null : match.first;
  }
  
  /**
   * Searches for clientid and returns the GClient instance
   */
  GClient findClient(String clientid) {
    var client;
    _games.forEach((g) {
      var c;
      if (null != (c = g.findClient(clientid))) client = c;
    });
    return client;
  }
  
  /**
   * Searches for the WebSocket and returns the associated game.
   */
  GServer findServerByWebSocket(WebSocket ws) {
    var match = _games.where((g) => g.participants.any((p) => p.ws == ws));
    return match.isEmpty ? null : match.first;
  }
  
  /**
   * Creates a new game and returns the game instance.
   */
  GServer createServer(GClient admin) {
    var id;
    do {
      id = generateGameID();
    } while (_games.any((g) => id == g.id));
    
    var game = new GServer(id, admin.id);
    _games.add(game);
    requestJoin(game, admin);
    return game;
  }
  
  /**
   * Creates a new [GClient] instance and returns it.
   */
  GClient createClient(String clientid, WebSocket ws) {
    return new GClient(clientid, ws);
  }
  
  /**
   * Tries to add the client to the game.
   */
  bool requestJoin(GServer game, GClient client) {
    return false; // [Todo] implement
  }
  
  /**
   * Tries to remove the client to the game.
   */
  bool requestLeave(GServer game, GClient client) {
    return false; // [Todo] implement
  }
  
  
}


/**
 * Representates a game.
 */
class GServer {
  /// A five-digit uniqe identifier.
  final String id;
  /// The clientid (uuid) of the person, who created the game.
  final String admin;
  /// A List of all clients connected to this game.
  List<GClient> participants = new List<GClient>();
  
  SendPort _sendPort;
  
  GServer(this.id, this.admin);
  
  /**
   * Searches for clientid and returns the GClient instance or null.
   */
  GClient findClient(String clientid) {
    var match = participants.where((p) => p.id == clientid);
    return match.isEmpty ? null : match.first;
  }
  
  /**
   * Processes an incomming message from a given client
   */
  void process(GClientRequest request, GClient client) {
    // ...
  }
  
  /**
   * Called when a WebSocket connection associated with this game disconnects.
   */
  void processLost(WebSocket ws) {
    
  }
  
  /**
   * Spawns a new Isolate and setups the communication to it.
   */
  Future<bool> _loadIsolate() {
    ReceivePort receivePort = new ReceivePort();
    receivePort.listen((msg) {
      if (_sendPort == null) {
        _sendPort = msg;
      } else {
        // [Todo] got msg
      }
    });
    return Isolate.spawnUri(Uri.parse(ISOLATE_PATH), [], receivePort.sendPort).then((isolate) {
      return true;
    });
  }
  
}


/**
 * Representates a Participant in a [GServer] and a connection to a client.
 */
class GClient {
  /// A uuid v4 that identifies a client.
  final String id;
  /// The name set by the user.
  String name;
  /// The socket connection to the client.
  WebSocket ws;
  
  GClient(this.id, [this.ws]);
  
  /// Returns true, if there is an active connection.
  bool get connected => ws != null && ws.readyState == WebSocket.OPEN;
  
}
