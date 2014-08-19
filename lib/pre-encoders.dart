part of transit;

abstract class PreEncoder extends Converter {

  _AbstractPreEncoding _newEncoding();
  WriteHandlers get handlers;

  convert(obj) {
    return _newEncoding().encodeTop(obj);
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
      
  _newEncoding() =>
      new _MsgPackPreEncoding(handlers);

}

class JsonPreEncoder extends PreEncoder{
  
  final WriteHandlers handlers = new WriteHandlers.built_in_json();
  
  _newEncoding() =>
      new _JsonPreEncoding(handlers);

}

class VerboseJsonPreEncoder extends PreEncoder{
  
  final WriteHandlers handlers = new WriteHandlers.built_in_json();
  
  _newEncoding() =>
      new _VerboseJsonPreEncoding(handlers);

}


