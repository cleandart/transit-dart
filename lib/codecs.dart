part of transit;

class MsgPackTransitCodec extends Codec<dynamic,List<int>>{
  
  final encoder = 
      new MsgPackPreEncoder().fuse(new MsgPackEncoder());
  
  final decoder = 
      new MsgPackDecoder().fuse(new PostDecoder());
}

class JsonTransitCodec extends Codec<dynamic,String>{
  
  final encoder = 
      new JsonPreEncoder().fuse(new JsonEncoder());
  
  final decoder = 
      new JsonDecoder().fuse(new PostDecoder());
}

class VerboseJsonTransitCodec extends Codec<dynamic,String>{
  
  final encoder =
      new VerboseJsonPreEncoder().fuse(new JsonEncoder.withIndent("  "));
  
  final decoder = 
      new JsonDecoder().fuse(new PostDecoder());
}



