part of transit;

class PostDecoder extends Converter{
  
  final Map<String, ReadHandler> handlers =
      new Map.from(standardReadHandlers);
  
  PostDecoding newDecoding(){
    return new PostDecoding(handlers);
  }
  
  register(String tag, ReadHandler handler){
    handlers[tag] = handler;
  }
  
  convert(obj){
    return newDecoding().decodeTop(obj);
  }
  
  Sink startChunkedConversion(Sink s) {
    return new _OneChunkTransformer(this.convert, s);
  }

}