library ricochetrobots.analytics;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

var _url = Platform.environment['ANALYTICS_URL'];
var _auth = Platform.environment['ANALYTICS_AUTH'];

/// Triggers the [event].
/// 
/// This function sends a http post request to the analytics logger.
void trigger(AnalyticsEvent event) {
  runZoned(() {
    if (_url == null) {
      print('Warning: Analytics event $event could not be triggered: No url specified.');
      return;
    }
    if (_auth == null) {
      print('Warning: Analytics event $event could not be triggered: No token specified.');
      return;
    }
    
    new HttpClient()..postUrl(_url)
         .then((HttpClientRequest request) {
           request.headers..add('X-Kinvey-API-Version', 3)
                          ..add('Authorization', _auth)
                          ..add('Content-Type', 'application/json');
           request.write(JSON.encode(event.data));
           return request.close();
         })
         .then((HttpClientResponse response) => response.drain(response))
         .then((HttpClientResponse response) {
           print('Analytics event $event logged with status ${response.statusCode}');
         });
  }, onError: (e) => print('Analytics Uncaught Error: $e'));
}

class AnalyticsEvent {
  
  Map _data;
  
  AnalyticsEvent(String type, Map data) {
    _data = data;
    _data['type'] = type;
  }
  
  Map get data => _data;
  
  @override
  String toString() => _data['type'];
  
}
