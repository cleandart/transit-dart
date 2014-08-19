part of transit;

class PostDecoder extends Converter{
  
  final Map<String, ReadHandler> handlers =
      new Map.from(_standardReadHandlers);
  
  _PostDecoding _newDecoding(){
    return new _PostDecoding(handlers);
  }
  
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