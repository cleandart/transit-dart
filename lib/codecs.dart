part of transit;

class MsgPackTransitCodec extends Codec<dynamic,List<int>>{
  
  final encoder = 
      new MsgPackPreEncoder().fuse(new MsgPackEncoder());
  
  final decoder = null;
}

class JsonTransitCodec extends Codec<dynamic,String>{
  
  final encoder = 
      new JsonPreEncoder().fuse(new JsonEncoder());
  
  final decoder = null;
}

class VerboseJsonTransitCodec extends Codec<dynamic,String>{
  
  final encoder =
      new VerboseJsonPreEncoder().fuse(new JsonEncoder.withIndent("  "));
  
  final decoder = null;
}



