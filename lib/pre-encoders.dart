part of transit;

/**
 * Base class of pre-encoders.
 * 
 * Pre-encoder applies Transit writing logic to the Dart object and
 * leaves it as serializable data.
 */
abstract class PreEncoder extends Converter {

  _AbstractPreEncoding _newEncoding();
  
  /**
   * [WriteHandlers] used by this encoder.
   */
  WriteHandlers get handlers;

  convert(obj) {
    return _newEncoding().encodeTop(obj);
  }

  /**
   * Registers [h] to encoder's [handlers].
   * 
   * [h] is an additional [WriteHandler] which
   * should be used for encoding.
   */
  register(WriteHandler h) {
    handlers.register(h);
  }

  Sink startChunkedConversion(Sink s) {
    return new _OneChunkTransformer(this.convert, s);
  }
}

/**
 * Applies Transit writing logic to object and converts it
 * to MsgPack serializable data.
 */
class MsgPackPreEncoder extends PreEncoder{
  
  final WriteHandlers handlers = new WriteHandlers.built_in_msgPack();
      
  _newEncoding() =>
      new _MsgPackPreEncoding(handlers);

}

/**
 * Applies Transit writing logic to object and converts it
 * to JSON serializable data.
 */
class JsonPreEncoder extends PreEncoder{
  
  final WriteHandlers handlers = new WriteHandlers.built_in_json();
  
  _newEncoding() =>
      new _JsonPreEncoding(handlers);

}

/**
 * Applies Transit writing logic to object and converts it
 * to human readable JSON serializable data.
 */
class VerboseJsonPreEncoder extends PreEncoder{
  
  final WriteHandlers handlers = new WriteHandlers.built_in_json();
  
  _newEncoding() =>
      new _VerboseJsonPreEncoding(handlers);

}


