part of ricochetrobots.messages;

@MessageType('connectResponse')
class ConnectResponseMessage extends MessageBase with MessageMixin {
  
  ConnectResponseMessage(clientId, [props]) : super(props) {
    _props['clientId'] = clientId;
  }
  ConnectResponseMessage.raw(props) : super(props);
  
}

@MessageType('reconnectRequest')
class ReconnectRequestMessage extends MessageBase with MessageMixin {
  
  ReconnectRequestMessage(clientId, [props]) : super(props) {
    _props['clientId'] = clientId;
  }
  ReconnectRequestMessage.raw(props) : super(props);
  
}

@MessageType('reconnectResponse')
class ReconnectResponseMessage extends MessageBase with MessageMixin {
  
  ReconnectResponseMessage(clientId, [props]) : super(props) {
    _props['clientId'] = clientId;
  }
  ReconnectResponseMessage.raw(props) : super(props);
  
}

@MessageType('gameCreateRequest')
class GameCreateRequestMessage extends MessageBase with MessageMixin {
  
  GameCreateRequestMessage(clientId, [props]) : super(props) {
    _props['clientId'] = clientId;
  }
  GameCreateRequestMessage.raw(props) : super(props);
  
}

@MessageType('gameCreateResponse')
class GameCreateResponseMessage extends MessageBase with MessageMixin {
  
  GameCreateResponseMessage(clientId, [props]) : super(props) {
    _props['clientId'] = clientId;
  }
  GameCreateResponseMessage.raw(props) : super(props);
  
}

@MessageType('formatError')
class FormatErrorMessage extends MessageBase with MessageMixin {
  
  FormatErrorMessage(clientId, [props]) : super(props) {
    _props['clientId'] = clientId;
  }
  FormatErrorMessage.raw(props) : super(props);
  
}

@MessageType('argumentError')
class ArgumentErrorMessage extends MessageBase with MessageMixin {
  
  ArgumentErrorMessage(clientId, [props]) : super(props) {
    _props['clientId'] = clientId;
  }
  ArgumentErrorMessage.raw(props) : super(props);
  
}

@MessageType('unsupportedError')
class UnsupportedErrorMessage extends MessageBase with MessageMixin {
  
  UnsupportedErrorMessage(clientId, [props]) : super(props) {
    _props['clientId'] = clientId;
  }
  UnsupportedErrorMessage.raw(props) : super(props);
  
}





