part of test;

testExamples() => group("Examples", () {
  
  var JSON = new JsonTransitCodec();
  var VerboseJSON = new VerboseJsonTransitCodec();  
  var MsgPack = new MsgPackTransitCodec();
  
  iterativeTest(Codec codec, data0)=>(){
    var obj1 = codec.decode(data0);
    var data1 = codec.encode(obj1);
    var obj2 = codec.decode(data1);
    var data2 = codec.encode(obj2);
    expect(obj2.toString(), equals(obj1.toString()));
    expect(data2, equals(data1));
  };
  
  Directory base = new Directory("../../transit-format/examples/0.8/");
  List<FileSystemEntity> files = base.existsSync() ? base.listSync(recursive: true) : [];
  
  for (FileSystemEntity f in files) if(f is File){
    if(f.path.endsWith(".verbose.json")){
      test(
        f.path.split("/").last,
        iterativeTest(VerboseJSON,f.readAsStringSync())
      );
    } else if (f.path.endsWith(".json")){
      test(
        f.path.split("/").last,
        iterativeTest(JSON,f.readAsStringSync())
      );
    } else if (f.path.endsWith(".mp")){
      test(
        f.path.split("/").last,
        iterativeTest(MsgPack,f.readAsBytesSync())
      );
    }
  }
  
    
});