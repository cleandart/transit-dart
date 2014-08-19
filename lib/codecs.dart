part of transit;

/**
 * Base class for encoders that provides full Transit encoding.
 * 
 * Fusion of Transit's [preEncoder] and serializating [mainEncoder]
 */
abstract class TransitEncoder<S,T> extends Converter<S,T>{
  
  /**
   * Provides Transit part of conversion
   */
  PreEncoder get preEncoder;
  
  /**
   * Provides serializating part of conversion
   */
  Converter get mainEncoder;
  
  Converter _me;
  
  TransitEncoder(){
    _me = preEncoder.fuse(mainEncoder);
  }
  
  convert(obj) => _me.convert(obj);
  
  startChunkedConversion(sink) => _me.startChunkedConversion(sink);
  
  /**
   * Registers [h] to be used for encoding objects
   * by [preEncoder].
   */
  register(WriteHandler h) => preEncoder.register(h);
}

/**
 * Base class for decoders that provides full Transit decoding.
 * 
 * Fusion of serializating [mainDecoder] and Transit's [postDecoder].
 */
abstract class TransitDecoder<S,T> extends Converter<S,T>{
  
  /**
   * Provides Transit part of conversion
   */
  PreEncoder get postDecoder;
  
  /**
   * Provides deserializating part of conversion
   */
  Converter get mainDecoder;
  
  Converter _me;
  
  TransitDecoder(){
    _me = mainDecoder.fuse(postDecoder);
  }
  
  convert(obj) => _me.convert(obj);
    
  startChunkedConversion(sink) => _me.startChunkedConversion(sink);
  
  /**
   * Registers [h] to be used for decoding [tag]
   * by [postDecoder].
   */
  register(WriteHandler h) => postDecoder.register(h);
}

/**
 * Encodes Dart object to MsgPack data.
 */
class MsgPackTransitEncoder extends TransitEncoder{
  
  final preEncoder = new MsgPackPreEncoder();
  final mainEncoder = new MsgPackEncoder();
}

/**
 * Decodes MsgPack data to Dart object.
 */
class MsgPackTransitDecoder extends TransitDecoder{
  
  final postDecoder = new PostDecoder();
  final mainDecoder = new MsgPackDecoder();
}

/**
 * Encodes Dart object to JSON data.
 */
class JsonTransitEncoder extends TransitEncoder{
  
  final preEncoder = new JsonPreEncoder();
  final mainEncoder = new JsonEncoder();
}

/**
 * Decodes JSON data to Dart object.
 */
class JsonTransitDecoder extends TransitDecoder{
  
  final postDecoder = new PostDecoder();
  final mainDecoder = new JsonDecoder();
}

/**
 * Encodes Dart object to human-readable JSON data.
 */
class VerboseJsonTransitEncoder extends TransitEncoder{
  
  final preEncoder = new VerboseJsonPreEncoder();
  final mainEncoder = new JsonEncoder.withIndent("  ");
}

/**
 * Decodes JSON data to Dart object.
 */
class VerboseJsonTransitDecoder extends TransitDecoder{
  
  final postDecoder = new PostDecoder();
  final mainDecoder = new JsonDecoder();
}

/**
 * A combination of [MsgPackTransitEncoder] and [MsgPackTransitDecoder].
 */
class MsgPackTransitCodec extends Codec<dynamic,List<int>>{
  
  final encoder = new MsgPackTransitEncoder();
  final decoder = new MsgPackTransitDecoder();
}

/**
 * A combination of [JsonTransitEncoder] and [JsonTransitDecoder].
 */
class JsonTransitCodec extends Codec<dynamic,String>{
  
  final encoder = new JsonTransitEncoder();
  final decoder = new JsonTransitDecoder();
}

/**
 * A combination of [VerboseJsonTransitEncoder]
 * and [VerboseJsonTransitDecoder].
 */
class VerboseJsonTransitCodec extends Codec<dynamic,String>{
  
  final encoder = new VerboseJsonTransitEncoder();
  final decoder = new VerboseJsonTransitDecoder();
}



