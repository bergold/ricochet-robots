
library ricochet_robots_backend;

import 'dart:convert';
import 'dart:io';
import 'dart:async';

import '../socketmanager.dart';

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

