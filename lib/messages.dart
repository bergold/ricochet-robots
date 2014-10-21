library ricochetrobots.messages;

class Message {
  
  final String type = 'default';
  final String clientId;
  Map _props;
  
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
    if (invocation.isAccessor && _props.containsKey(invocation.memberName)) {
      if (invocation.isSetter) {
        _props[invocation.memberName] = invocation.positionalArguments.first;
      } else {
        return _props[invocation.memberName];
      }
    } else {
      super.noSuchMethod(invocation);
    }
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
