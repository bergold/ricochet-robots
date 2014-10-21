library ricochetrobots.messages;

class Message {
  
  final String clientId;
  Map _props;
  
  Message(this.clientId);
  
  Message.fromJson(Map json) :
      this.clientId = json['clientId'],
      this._props = new Map.from(json)..remove('clientId');
  
  Object toJson() {
    return {
      'clientId': clientId
    };
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
