library ricochetrobots.analytics;

import 'dart:convert';
import 'dart:io';

var _url = Platform.environment['ANALYTICS_URL'];
var _token = Platform.environment['ANALYTICS_TOKEN'];

/// Triggers the [event].
/// 
/// This function sends a http post request to the analytics logger.
void trigger(String event, [Map data = null]) {
  if (_url == null) {
    print('Warning: $event could not be triggered: No url specified.');
    return;
  }
  if (_token == null) {
    print('Warning: $event could not be triggered: No token specified.');
    return;
  }
  
  if (data == null) data = {};
  
  new HttpClient()..postUrl(_url)
       .then((HttpClientRequest request) {
         request.headers..add('Content-Type', 'application/json')
                        ..add('X-Analytics-Event', event)
                        ..add('X-Analytics-Token', _token);
         request.write(JSON.encode(data));
         return request.close();
       })
       .then((HttpClientResponse response) => response.drain(response))
       .then((HttpClientResponse response) {
         print('Event $event logged with status ${response.statusCode}');
       });
  
}
