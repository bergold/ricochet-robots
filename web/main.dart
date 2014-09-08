import 'dart:html';

WebSocket ws;

void main() {
  
  querySelector("#btn_connect").onClick.listen((e) {
    if (!(ws != null && ws.readyState == WebSocket.OPEN)) {
      doConnect((querySelector("#txt_url") as InputElement).value);
      querySelector("#btn_connect").text = 'Disconnect';
    } else {
      doDisconnect();
      querySelector("#btn_connect").text = 'Connect';
    }
  });
  
  querySelector("#btn_send").onClick.listen((e) {
    doSend((querySelector("#txt_msg") as TextAreaElement).value);
  });
  
}

void insert(Element el) {
  querySelector(".logger").insertBefore(el, querySelector("#msg_input"));
}

void log(String msg) {
  print(msg);
  var el = new DivElement();
  el.classes.add('log');
  el.text = msg;
  insert(el);
}

void logMsg(String name, String data) {
  var el = new DivElement();
  el.classes.add('message');
  el.classes.add('flex-split');
  el.setInnerHtml('<span class="msg-name flex-side">$name</span><div class="msg-data flex-main"><pre>$data</pre></div>');
  insert(el);
}

void doConnect(String url) {
  
  log('Connecting to \'$url\'');
  ws = new WebSocket(url);
  
  ws.onOpen.listen((e) {
    log('Connected');
  });

  ws.onClose.listen((e) {
    log('WebSocket closed: ${e.code} ${e.reason}');
  });

  ws.onError.listen((e) {
    log("Error connecting to WebSocket");
  });

  ws.onMessage.listen((MessageEvent e) {
    logMsg('Server', e.data);
    print('Received message: ${e.data}');
  });
  
}

void doSend(String data) {
  if (ws != null && ws.readyState == WebSocket.OPEN) {
    ws.send(data);
    logMsg('Client', data);
    print('Sent message: $data');
  } else {
    log('Error: WebSocket not connected.');
  }
}

void doDisconnect() {
  ws.close();
  log('WebSocket closed');
}
