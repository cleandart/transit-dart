part of transit;

abstract class TransitEncoder<S,T> extends Converter<S,T>{
  
  PreEncoder get preEncoder;
  Converter get mainEncoder;
  
  Converter _me;
  
  TransitEncoder(){
    _me = preEncoder.fuse(mainEncoder);
  }
  
  convert(obj) => _me.convert(obj);
  
  startChunkedConversion(sink) => _me.startChunkedConversion(sink);
  
  register(WriteHandler h) => preEncoder.register(h);
}

abstract class TransitDecoder<S,T> extends Converter<S,T>{
  
  PreEncoder get postDecoder;
  Converter get mainDecoder;
  
  Converter _me;
  
  TransitDecoder(){
    _me = mainDecoder.fuse(postDecoder);
  }
  
  convert(obj) => _me.convert(obj);
    
  startChunkedConversion(sink) => _me.startChunkedConversion(sink);
  
  register(WriteHandler h) => postDecoder.register(h);
}

class MsgPackTransitEncoder extends TransitEncoder{
  
  final preEncoder = new MsgPackPreEncoder();
  final mainEncoder = new MsgPackEncoder();
}

class MsgPackTransitDecoder extends TransitDecoder{
  
  final postDecoder = new PostDecoder();
  final mainDecoder = new MsgPackDecoder();
}

class JsonTransitEncoder extends TransitEncoder{
  
  final preEncoder = new JsonPreEncoder();
  final mainEncoder = new JsonEncoder();
}

class JsonTransitDecoder extends TransitDecoder{
  
  final postDecoder = new PostDecoder();
  final mainDecoder = new JsonDecoder();
}

class VerboseJsonTransitEncoder extends TransitEncoder{
  
  final preEncoder = new VerboseJsonPreEncoder();
  final mainEncoder = new JsonEncoder.withIndent("  ");
}

class VerboseJsonTransitDecoder extends TransitDecoder{
  
  final postDecoder = new PostDecoder();
  final mainDecoder = new JsonDecoder();
}

class MsgPackTransitCodec extends Codec<dynamic,List<int>>{
  
  final encoder = new MsgPackTransitEncoder();
  final decoder = new MsgPackTransitDecoder();
}

class JsonTransitCodec extends Codec<dynamic,String>{
  
  final encoder = new JsonTransitEncoder();
  final decoder = new JsonTransitDecoder();
}

class VerboseJsonTransitCodec extends Codec<dynamic,String>{
  
  final encoder = new VerboseJsonTransitEncoder();
  final decoder = new VerboseJsonTransitDecoder();
}



