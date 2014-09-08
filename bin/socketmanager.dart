
part of ricochet_robots_backend;


/**
 * Manages different sockets.
 */
class SocketManager {
  
  final GServerManager gServerManager;
  
  SocketManager() : gServerManager = new GServerManager();
  
  /**
   * Handles new websocket connections.
   */
  void handler(WebSocket ws) {
    ws.map((string) => JSON.decode(string)).listen((json) {
      try {
        _processIncome(ws, json);
      } on SocketException catch(ex) {
        _processException(ws, ex);
      }
    }, onDone: () {
      _processLost(ws);
    });
  }
  
  /**
   * Processes WebSocket requests.
   */
  void _processIncome(WebSocket ws, json) {
    
    var req = new GClientRequest(json);
    
    if (req.isType('connect')) {
      if (!req.hasGameID() || !req.hasClientID())
        throw new SocketException.invalidRequest('Connect requests need a clientid and a gameid specified.', type: SocketException.TYPE_REQUEST);
      _processConnect(ws, req);
      return;
    }
    
    if (req.isType('create')) {
      if (!req.hasClientID())
        throw new SocketException.invalidRequest('Create requests need a clientid specified.', type: SocketException.TYPE_REQUEST);
      _processCreate(ws, req);
      return;
    }
    
    if (req.isType('close')) {
      if (!req.hasGameID() || !req.hasClientID())
        throw new SocketException.invalidRequest('Close requests need a clientid and a gameid specified.', type: SocketException.TYPE_REQUEST);
      _processClose(ws, req);
      return;
    }
    
    if (req.hasClientID() && req.hasGameID()) {
      _processOther(ws, req);
      return;
    }
    
    throw new SocketException.invalidRequest('No named type and no clientid or gameid specified.', type: SocketException.TYPE_REQUEST);
    
  }
  
  void _processConnect(WebSocket ws, GClientRequest request) {
    var gameid = request.gameid;
    var clientid = request.clientid;
    
    if (null != gServerManager.findClient(clientid))
      throw new SocketException.invalidClientID('The clientid \'$clientid\' already exists.', type: SocketException.TYPE_CONNECT);
      
    var game = gServerManager.findServer(gameid);
    if (null == game)
      throw new SocketException.invalidGameID('The game with the id \'$gameid\' doesn\'t exists.', type: SocketException.TYPE_CONNECT);
    
    var client = gServerManager.createClient(clientid, ws);
    var result = gServerManager.requestJoin(game, client);
    if (!result)
      throw new SocketException.connectFailed('Connecting to the game failed.', type: SocketException.TYPE_CONNECT);
    
    var data = new Map();
    data['response'] = 'connect';
    data['status'] = 'success';
    data['gameid'] = gameid;
    ws.add(JSON.encode(data));
  }
  
  void _processCreate(WebSocket ws, GClientRequest request) {
    var clientid = request.clientid;
    
    if (null != gServerManager.findClient(clientid))
      throw new SocketException.invalidClientID('The clientid \'$clientid\' already exists.', type: SocketException.TYPE_CREATE);
      
    var client = gServerManager.createClient(clientid, ws);
    var game = gServerManager.createServer(client);
    
    var data = new Map();
    data['response'] = 'create';
    data['status'] = 'success';
    data['gameid'] = game.id;
    ws.add(JSON.encode(data));
  }
  
  void _processOther(WebSocket ws, GClientRequest request) {
    var gameid = request.gameid;
    var clientid = request.clientid;
    
    var game = gServerManager.findServer(gameid);
    if (null == game)
      throw new SocketException.invalidGameID('The game with the id \'$gameid\' doesn\'t exists.', type: SocketException.TYPE_OTHER);
    
    var client = game.findClient(clientid);
    if (null == client)
      throw new SocketException.invalidClientID('The client isn\'t registered in this game.', type: SocketException.TYPE_OTHER);
    if (!client.connected)
      throw new SocketException.clientDisconnected('This client has no active WebSocket connection.', type: SocketException.TYPE_OTHER);
    if (client.ws != ws)
      throw new SocketException.invalidWebSocket('This WebSocket and the WebSocket which is associated with this clientid aren\'t the same.', type: SocketException.TYPE_OTHER);
      
    game.process(request, client);
  }
  
  void _processClose(WebSocket ws, GClientRequest request) {
    var gameid = request.gameid;
    var clientid = request.clientid;
    
    var game = gServerManager.findServer(gameid);
    if (null == game)
      throw new SocketException.invalidGameID('The game with the id \'$gameid\' doesn\'t exists.', type: SocketException.TYPE_OTHER);
    
    var client = game.findClient(clientid);
    if (null == client)
      throw new SocketException.invalidClientID('The client isn\'t registered in this game.', type: SocketException.TYPE_OTHER);
    if (!client.connected)
      throw new SocketException.clientDisconnected('This client has no active WebSocket connection.', type: SocketException.TYPE_OTHER);
    if (client.ws != ws)
      throw new SocketException.invalidWebSocket('This WebSocket and the WebSocket which is associated with this clientid aren\'t the same.', type: SocketException.TYPE_OTHER);
      
    var result = gServerManager.requestLeave(game, client);
    if (!result)
      throw new SocketException.leaveFailed('Leaving the game failed.', type: SocketException.TYPE_LEAVE);
    
    var data = new Map();
    data['response'] = 'close';
    data['status'] = 'success';
    ws.add(JSON.encode(data));
  }
  
  void _processLost(WebSocket ws) {
    var game = gServerManager.findServerByWebSocket(ws);
    if (null != game) game.processLost(ws);
  }
  
  void _processException(WebSocket ws, ex) {
    ws.add(ex.toJsonString());
  }
  
}


/**
 * This class parses the incomming websocket messages.
 * It provides helper functions.
 */
class GClientRequest {
  final json;
  
  GClientRequest(this.json);
  
  /// Returns true if the field key is set.
  bool isSet(String key) {
    return json.containsKey(key);
  }
  
  /// Returns true when type matches the request type.
  bool isType(String type) {
    return isSet('request') && json['request'] == type;
  }
  
  /// Returns true when gameid is set and is a proper gameid.
  bool hasGameID() {
    var regex = new RegExp(r'^[0-9a-z]{5}$', caseSensitive: false);
    return isSet('gameid') && regex.hasMatch(json['gameid']);
  }
  
  /// Returns true when clientid is set and is a proper clientid.
  bool hasClientID() {
    var regex = new RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[0-9a-f]{4}-[0-9a-f]{12}$', caseSensitive: false);
    return isSet('clientid') && regex.hasMatch(json['clientid']);
  }
  
  /// Returns the request type.
  String get type => json['request'];
  
  /// Returns the gameid or null.
  String get gameid => hasGameID() ? json['gameid'] : null;
  
  /// Returns the clientid or null.
  String get clientid => hasClientID() ? json['clientid'] : null;
  
}
