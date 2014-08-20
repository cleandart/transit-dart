part of transit;

class _OneChunkTransformer extends ChunkedConversionSink<Object> {

  final transformer;
  final Sink target;
  bool used = false;

  _OneChunkTransformer(this.transformer, this.target);
  
  add(obj){
    if(!used){
      target.add(transformer(obj));
      used = true;
    } else {
      throw new StateError("Only one call to add allowed");
    }
  }
  
  close(){
    target.close();
  }

}

bool _isCacheable(s){
  return s.length > 1 && ['~#','~\$','~:'].contains(s.substring(0,2));
}