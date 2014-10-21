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
    setUp(() {
      msg = new Message('client-id');
    });
    
    test('clientId-Getter', () {
      expect('client-id', msg.clientId);
    });
    
    group('_props-Accessors', () {
      
      setUp(() {
        msg.propOne = 5;
        msg.propTwo = 'propTwoVal';
      });
      
      test('getter', () {
        expect(5, msg.propOne);
        expect('propTwoVal', msg.propTwo);
      });
      
    });
    
  });
}
