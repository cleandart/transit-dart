part of test;

testEncoding() => group("Encoding", () {
  
  var JSON = new JsonPreEncoder();
  var VERBOSE_JSON = new VerboseJsonPreEncoder();
  var MSGPACK = new MsgPackPreEncoder();
  
  group("MsgPack", () { for(var row in DATA){
    test(row[0].toString(), () {
      expect(MSGPACK.convert(row[0]),equals(row[1]));
    });
  }});
    
  group("JSON", () { for(var row in DATA){
    test(row[0].toString(), () {
      expect(JSON.convert(row[0]),equals(row[2]));
    });
  }});
  
  group("verbose-JSON", () { for(var row in DATA){
    test(row[0].toString(), () {
      expect(VERBOSE_JSON.convert(row[0]),equals(row[3]));
    });
  }});
    
});