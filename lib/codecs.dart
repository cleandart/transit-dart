part of transit;

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

