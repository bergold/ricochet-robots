library ricochetrobots.messages;

@MirrorsUsed(metaTargets: MessageType, symbols: '*')
import 'dart:mirrors';
import 'dart:convert';

part 'src/messages_types.dart';

/// This class is used as a metadata for subtypes of Message
/// to define the type as String used in Json out- and input.
class MessageType {
  final String type;
  const MessageType(this.type);
}

@proxy
abstract class MessageBase {
  
  Map _props;
  
  MessageBase(this._props) {
    if (_props == null) _props = new Map<String, Object>();
  }
  
  factory MessageBase.fromJson(json, { bool asString: false }) {
    if (asString) json = JSON.decode(json);
    
    var type = json['type'];
    type = type == null ? 'default' : type;
    
    var props = new Map.from(json)..remove('type');
    
    var subclassMirror = getClassToType(type);
    
    if (subclassMirror != null) {
      return subclassMirror.newInstance(new Symbol('raw'), [props]).reflectee;
    } else {
      throw new UnsupportedError('The message type $type could not be found.');
    }
  }
  
  static ClassMirror getClassToType(String type) {
    var ms = currentMirrorSystem();
    var thisLib = ms.findLibrary(#ricochetrobots.messages);
    var matches = thisLib.declarations.values.where((d) =>
        d is ClassMirror &&
        (d as ClassMirror).isSubclassOf(reflectClass(MessageBase)) &&
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

class MessageMixin {
  
  String get type {
    var classMirror = reflect(this).type;
    var typeMirror = classMirror.metadata.singleWhere((m) =>
        m.hasReflectee &&
        m.reflectee is MessageType);
    return (typeMirror.reflectee as MessageType).type;
  }
  
}

@MessageType('default')
class Message extends MessageBase with MessageMixin {
  
  Message(clientId, [props]) : super(props) {
    _props['clientId'] = clientId;
  }
  
  Message.raw(props) : super(props) {
    if (props['clientId'] == null) throw new ArgumentError('The field clientId is required.');
  }
  
}
