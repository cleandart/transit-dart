library test;

import "dart:collection";
import "dart:io";
import "dart:convert";
import "package:unittest/unittest.dart";
import "package:transit/transit.dart";

part "cache_test.dart";
part "pre-encoders_test.dart";
part "post-decoders_test.dart";
part "example_test.dart";
part "testdata.dart";

void main(){
  
  testCache();
  testEncoding();
  testDecoding();
  testExamples();
  
}