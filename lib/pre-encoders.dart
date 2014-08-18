part of transit;

abstract class PreEncoder extends Converter {

  AbstractPreEncoding newEncoding();
  WriteHandlers get handlers;

  convert(obj) {
    return newEncoding().encodeTop(obj);
  }

  register(WriteHandler h) {
    handlers.register(h);
  }

  Sink startChunkedConversion(Sink s) {
    return new _OneChunkTransformer(this.convert, s);
  }
}

class MsgPackPreEncoder extends PreEncoder{
  
  final WriteHandlers handlers = new WriteHandlers.built_in_msgPack();
      
  newEncoding() =>
      new MsgPackPreEncoding(handlers);

}

class JsonPreEncoder extends PreEncoder{
  
  final WriteHandlers handlers = new WriteHandlers.built_in_json();
  
  newEncoding() =>
      new JsonPreEncoding(handlers);

}

class VerboseJsonPreEncoder extends PreEncoder{
  
  final WriteHandlers handlers = new WriteHandlers.built_in_json();
  
  newEncoding() =>
      new VerboseJsonPreEncoding(handlers);

}


