library ricochetrobots.test;

import 'package:unittest/compact_vm_config.dart';

import 'messages_test.dart' as messages;

void main() {
  
  useCompactVMConfiguration();
  
  messages.main();
  
}
