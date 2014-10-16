
library ricochet_robots_backend;

import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'dart:isolate';

part 'socketmanager.part.dart';
part 'gamemanager.part.dart';

void main() {
  
  var host = InternetAddress.LOOPBACK_IP_V4;
  var port = Platform.environment.containsKey('PORT') ? Platform.environment['PORT'] : 5000;
  
  SocketManager socketManager = new SocketManager();
  HttpManager httpManager = new HttpManager();
  
  runZoned(() {
    HttpServer.bind(host, port).then((server) {
      print('Server is running on \'http://${server.address.address}:${server.port}/\'');
      
      StreamController sc = new StreamController();
      sc.stream.transform(new WebSocketTransformer()).listen((WebSocket ws) {
        socketManager.handler(ws);
      });
      
      server.listen((HttpRequest request) {
        if (request.uri.path == '/') {
          request.response.write('Hello world from Dart on Heroku');
          request.response.close();
        } else if (request.uri.path == '/ws') {
          sc.add(request);
        } else {
          httpManager.sendError(HttpStatus.NOT_FOUND, request);
        }
      });
      
    });
  }, onError: (e, stackTrace) => print('HttpServer Error! $e $stackTrace'));
  
}


class HttpManager {
  
  void sendError(int code, HttpRequest request) {
    var res = request.response;
    var data = new Map();
    res.statusCode = code;
    res.headers.contentType = new ContentType("application", "json", charset: "utf-8");
    res.write(JSON.encode(data));
    res.close();
  }
  
}


class SocketException implements Exception {
  static const String TYPE_UNKNOWN = 'unknown';
  static const String TYPE_REQUEST = 'request';
  static const String TYPE_CONNECT = 'connect';
  static const String TYPE_CREATE = 'create';
  static const String TYPE_LEAVE = 'leave';
  static const String TYPE_OTHER = 'other';
  
  static const int INVALID_REQUEST = 1;
  static const int INVALID_CLIENTID = 2;
  static const int INVALID_GAMEID = 3;
  static const int INVALID_WEBSOCKET = 4;
  static const int CONNECTING_FAILED = 5;
  static const int LEAVING_FAILED = 6;
  static const int CLIENT_DISCONNECTED = 7;
  
  final String type;
  final int code;
  final String codeName;
  final String message;
  
  SocketException(this.code, this.codeName, this.message, { this.type: SocketException.TYPE_UNKNOWN });
  
  SocketException.invalidRequest(this.message, { this.type: SocketException.TYPE_UNKNOWN }) :
      code = SocketException.INVALID_REQUEST,
      codeName = 'INVALID_REQUEST';
  
  SocketException.invalidClientID(this.message, { this.type: SocketException.TYPE_UNKNOWN }) :
      code = SocketException.INVALID_CLIENTID,
      codeName = 'INVALID_CLIENTID';
  
  SocketException.invalidGameID(this.message, { this.type: SocketException.TYPE_UNKNOWN }) :
      code = SocketException.INVALID_GAMEID,
      codeName = 'INVALID_GAMEID';
  
  SocketException.invalidWebSocket(this.message, { this.type: SocketException.TYPE_UNKNOWN }) :
      code = SocketException.INVALID_WEBSOCKET,
      codeName = 'INVALID_WEBSOCKET';
  
  SocketException.connectFailed(this.message, { this.type: SocketException.TYPE_UNKNOWN }) :
      code = SocketException.CONNECTING_FAILED,
      codeName = 'CONNECTING_FAILED';
  
  SocketException.leaveFailed(this.message, { this.type: SocketException.TYPE_UNKNOWN }) :
      code = SocketException.LEAVING_FAILED,
      codeName = 'LEAVING_FAILED';
  
  SocketException.clientDisconnected(this.message, { this.type: SocketException.TYPE_UNKNOWN }) :
      code = SocketException.CLIENT_DISCONNECTED,
      codeName = 'CLIENT_DISCONNECTED';
  
  toJson() {
    return {
      "response": "error",
      "type": type,
      "code": code, 
      "codeName": codeName, 
      "message": message
    };
  }
  
  String toJsonString() {
    return JSON.encode(toJson());
  }
  
}
