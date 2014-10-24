library ricochetrobots.test.messages;

import 'package:unittest/unittest.dart';

import 'package:ricochetrobots/messages.dart';

void main() {
  group('messages', () {
    
    group_message();
    
  });
}

void group_message() {
  group('Message', () {
    var msg;
    
    group('#default constructor', () {
      setUp(() {
        msg = new Message('client-id');
      });
      
      test('should return the clientId', () {
        expect(msg.clientId, equals('client-id'));
      });
      
      test('should return the default type as string', () {
        expect(msg.type, equals('default'));
      });
    });
    
    group('#default constructor with props', () {
      setUp(() {
        msg = new Message('client-id', {
          'propOne': 5,
          'propTwo': 'propTwoVal'
        });
      });
      
      test('should return the initial value', () {
        expect(msg.propOne, equals(5));
        expect(msg.propTwo, equals('propTwoVal'));
      });
      
      test('should return the set value', () {
        msg.propFoo = 32.2343;
        msg.propBar = 'hallo';
        expect(msg.propFoo, equals(32.2343));
        expect(msg.propBar, equals('hallo'));
      });
    });
    
    group('#fromJson constructor with no type', () {
      setUp(() {
        msg = new Message.fromJson({
          'clientId': 'my-client-id',
          'propFoo': 'foo',
          'propBar': 123
        });
      });
      
      test('should be the default type', () {
        expect(msg is Message, equals(true));
      });
      
      test('should return the type used in json', () {
        expect(msg.type, equals('default'));
      });
      
      test('should return the clientId that is declared in the json', () {
        expect(msg.clientId, equals('my-client-id'));
      });
    });
    
    group('#fromJson constructor with type', () {
      setUp(() {
        msg = new Message.fromJson({
          'clientId': 'connect-client-id',
          'type': 'connectResponse',
          'propFoo': 'foo',
          'propBar': 123
        });
      });
      
      test('should be an instance of ConnectResponseMessage', () {
        expect(msg is ConnectResponseMessage, equals(true));
      });
      
      test('should return the type used in json', () {
        expect(msg.type, equals('connectResponse'));
      });
      
      test('clientId should be accessable', () {
        expect(msg.clientId, equals('connect-client-id'));
      });
      
      test('props should be accessable', () {
        expect(msg.propFoo, equals('foo'));
        expect(msg.propBar, equals(123));
        msg.fooBar = 'batman';
        expect(msg.fooBar, equals('batman'));
      });
    });
    
  });
}
