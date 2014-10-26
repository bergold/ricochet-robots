part of ricochetrobots.messages;

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
  final String type = 'reconnectResponse';
  
  ReconnectResponseMessage(clientId, [props]) : super(clientId, props);
  
}

class GameCreateRequestMessage extends Message {
  
  @override
  final String type = 'gameCreateRequest';
  
  GameCreateRequestMessage(clientId, [props]) : super(clientId, props);
  
}

class GameCreateResponseMessage extends Message {
  
  @override
  final String type = 'gameCreateResponse';
  
  GameCreateResponseMessage(clientId, [props]) : super(clientId, props);
  
}

class FormatErrorMessage extends Message {
  
  @override
  final String type = 'formatError';
  
  FormatErrorMessage(clientId, [props]) : super(clientId, props);
  
}

class ArgumentErrorMessage extends Message {
  
  @override
  final String type = 'argumentError';
  
  ArgumentErrorMessage(clientId, [props]) : super(clientId, props);
  
}




