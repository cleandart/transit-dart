part of transit;

/**
 * Converts deserialized data to the regular Dart object
 * using Transit read logic
 */
class PostDecoder extends Converter{
  
  /**
   * Used to map tags to their [ReadHandlers]
   * during decoding.
   */
  final Map<String, ReadHandler> handlers =
      new Map.from(_standardReadHandlers);
  
  _PostDecoding _newDecoding(){
    return new _PostDecoding(handlers);
  }
  
  /**
   * Registers [handler] to be used for decoding [tag]
   * by the converter.
   */
  register(String tag, ReadHandler handler){
    handlers[tag] = handler;
  }
  
  convert(obj){
    return _newDecoding().decodeTop(obj);
  }
  
  Sink startChunkedConversion(Sink s) {
    return new _OneChunkTransformer(this.convert, s);
  }

}