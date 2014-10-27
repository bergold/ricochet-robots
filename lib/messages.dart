library ricochetrobots.messages;

@MirrorsUsed(metaTargets: MessageType)
import 'dart:mirrors';
import 'dart:convert';

part 'src/messages_default.dart';

class MessageType {
  final String type;
  const MessageType(this.type);
}

@proxy
class Message {
  
  final String type = 'default';
  final String clientId;
  Map _props;
  
  Message(this.clientId, [this._props]) {
    if (_props == null) _props = new Map<String, Object>();
  }
  
  factory Message.fromJson(json, { bool asString: false }) {
    if (asString) json = JSON.decode(json);
    var clientId = json['clientId'];
    if (clientId == null) throw new ArgumentError('The field clientId is required.');
    var type = json['type'];
    type = type == null ? 'default' : type;
    var props = new Map.from(json)..remove('clientId')..remove('type');
    
    var subclassMirror = getClassToType(type);
    
    if (subclassMirror != null) {
      return subclassMirror.newInstance(new Symbol(''), clientId, props).reflectee;
    } else {
      return new Message(clientId, props); 
    }
  }
  
  static ClassMirror getClassToType(String type) {
    var ms = currentMirrorSystem();
    var rootLib = ms.isolate.rootLibrary;
    var matches = rootLib.declarations.values.where((d) =>
        d is ClassMirror &&
        (d as ClassMirror).isSubclassOf(reflectClass(Message)) &&
        d.metadata.any((m) =>
            m.hasReflectee &&
            m.reflectee is MessageType &&
            (m.reflectee as MessageType).type == type));
    return matches.isNotEmpty ? matches.single : null;
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
  
  bool has(String prop) {
    return _props.containsKey(prop);
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
