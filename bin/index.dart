library ricochet_robots_backend;

import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_route/shelf_route.dart' as shelf_route;
import 'package:shelf_static/shelf_static.dart' as shelf_static;
import 'package:shelf_web_socket/shelf_web_socket.dart' as shelf_ws;

import 'socketmanager.dart';

void main() {
  
  /// Get host and port to bind to.
  var host = InternetAddress.ANY_IP_V4;
  var portEnv = Platform.environment['PORT'];
  var port = portEnv == null ? 5000: int.parse(portEnv);
  
  /// Defines the path and handler to serve static.
  var webPath = path.join(path.dirname(Platform.script.toFilePath()), '..', 'build/web');
  var webHandler = shelf_static.createStaticHandler(webPath, defaultDocument: 'index.html');

  /// Get the path to bind the ws server to.
  var wsPathEnv = Platform.environment['WS_PATH'];
  var wsPath = wsPathEnv == null ? '/ws' : wsPathEnv;
  
  /// Create a handler to handle new websockets.
  var socketManager = new SocketManager();
  var wsHandler = shelf_ws.webSocketHandler((ws) {
    socketManager.handler(ws);
  });
  
  var router = shelf_route.router(fallbackHandler: webHandler);
  router.get(wsPath, wsHandler);
  
  runZoned(() {
    
    shelf_io.serve(router.handler, host, port).then((_) {
      print('Server is listening on $host:$port');
    });
    
  }, onError: (e, StackTrace stacktrace) => print("Error $e: $stacktrace"));
  
}
