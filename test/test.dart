library test;

import "dart:collection";
import "package:unittest/unittest.dart";
import "package:transit/transit.dart";

part "cache_test.dart";
part "pre-encoders_test.dart";
part "testdata.dart";

void main(){
  
  testCache();
  testEncoding();
  
}