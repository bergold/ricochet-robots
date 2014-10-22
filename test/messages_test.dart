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
    
    group('default constructor', () {
      setUp(() {
        msg = new Message('client-id');
      });
      
      test('clientId-Getter', () {
        expect(msg.clientId, equals('client-id'));
      });
      
      test('type-Getter', () {
        expect(msg.type, equals('default'));
      });
      
      group('_props-Accessors', () {
        setUp(() {
          msg.propOne = 5;
          msg.propTwo = 'propTwoVal';
        });
        
        test('getter', () {
          expect(msg.propOne, equals(5));
          expect(msg.propTwo, equals('propTwoVal'));
        });
      });
    });
    
    group('fromJson constructor', () {
      setUp(() {
        msg = new Message.fromJson({
          'clientId': 'client-id',
          'propFoo': 'foo',
          'propBar': 123
        });
      });
      
      test('clientId-Getter', () {
        expect(msg.clientId, equals('client-id'));
      });
      
      test('type-Getter', () {
        expect(msg.type, equals('default'));
      });
    });
    
  });
}
