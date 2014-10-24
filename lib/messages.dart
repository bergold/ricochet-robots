library ricochetrobots.messages;

import 'dart:convert';
import 'dart:mirrors';

class Message {
  
  final String type = 'default';
  final String clientId;
  Map _props = new Map<String, Object>();
  
  Message(this.clientId, [this._props]);
  
  factory Message.fromJson(json, { bool asString: false }) {
    if (asString) json = JSON.decode(json);
    var clientId = json['clientId'];
    var type = json['type'];
    type = type == null ? 'default' : type;
    var props = new Map.from(json)..remove('clientId')..remove('type');
    
    switch (type) {
      case 'connectResponse':
        return new ConnectResponseMessage(clientId, props);
      case 'reconnectRequest':
        return new ReconnectRequestMessage(clientId, props);
      case 'reconnectResponse':
        return new ReconnectResponseMessage(clientId, props);
      case 'disconnect':
      case 'gameJoinRequest':
      case 'gameJoinResponse':
      case 'gameUserListUpdate':
      case 'gameRoundUpdate':
        throw new UnimplementedError();
      default:
        return new Message(clientId, props);
    }
  }
  
  toJson({ bool asString: false }) {
    var json = {
      'clientId': clientId,
      'type': type
    };
    json.addAll(_props);
    if (asString) return JSON.encode(json);
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

class ConnectResponseMessage extends Message {
  
  @override
  final String type = 'connectResponse';
  
  ConnectResponseMessage(clientId, [props]) : super(clientId, props);
  
}

class ReconnectRequestMessage extends Message {
  
  @override
  final String type = 'reconnectRequest';
  
  ReconnectRequestMessage(clientId, [props]) : super(clientId, props);
  
}

class ReconnectResponseMessage extends Message {
  
  @override
  final String type = 'reconnectRequest';
  
  ReconnectResponseMessage(clientId, [props]) : super(clientId, props);
  
}
