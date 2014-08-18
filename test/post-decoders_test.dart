part of test;

_ignoreMapEnforcer(obj){
  if(obj is TaggedValue && obj.tag == "map") return obj.rep;
  return obj;
}

testDecoding() => group("Decoding", () {
  
  var DECODER = new PostDecoder();
  
  group("MsgPack", () { for(var row in DATA){
    test(row[0].toString(), () {
      expect(
          DECODER.convert(row[1]).toString(),
          equals(_ignoreMapEnforcer(row[0]).toString())
      );
    });
  }});
    
  group("JSON", () { for(var row in DATA){
    test(row[0].toString(), () {
      expect(
          DECODER.convert(row[2]).toString(),
          equals(_ignoreMapEnforcer(row[0]).toString())
      );
    });
  }});
  
  group("verbose-JSON", () { for(var row in DATA){
    test(row[0].toString(), () {
      expect(
          DECODER.convert(row[3]).toString(),
          equals(_ignoreMapEnforcer(row[0]).toString())
      );
    });
  }});
    
});