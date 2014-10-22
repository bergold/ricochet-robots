library ricochetrobots.messages;

import 'dart:mirrors';

class Message {
  
  final String type = 'default';
  final String clientId;
  Map _props = new Map<String, Object>();
  
  Message(this.clientId);
  
  Message.fromJson(Map json) :
      this.clientId = json['clientId'],
      this._props = new Map.from(json)..remove('clientId');
  
  Map toJson() {
    var json = {
      'clientId': clientId,
      'type': type
    };
    json.addAll(_props);
    return json;
  }
  
  @override
  noSuchMethod(Invocation invocation) {
    if (invocation.isAccessor) {
      var prop = MirrorSystem.getName(invocation.memberName);
      if (invocation.isGetter) {
        if (_props.containsKey(prop)) {
          return _props[prop];
        }
        return super.noSuchMethod(invocation);
      }
      if (invocation.isSetter) {
        prop = prop.substring(0, prop.length - 1);
        _props[prop] = invocation.positionalArguments.first;
        return null;
      }
    }
    return super.noSuchMethod(invocation);
  }
  
}

class ReconnectRequestMessage extends Message {
  
  @override
  final String type = 'reconnectRequest';
  
  ReconnectRequestMessage(clientId) : super(clientId);
  
}

class ConnectResponseMessage extends Message {
  
  @override
  final String type = 'reconnectRequest';
  
  ConnectResponseMessage(clientId) : super(clientId);
  
}
