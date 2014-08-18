part of transit;

class _OneChunkTransformer extends ChunkedConversionSink<Object> {

  final _transformer;
  final Sink _target;
  bool _used = false;

  _OneChunkTransformer(this._transformer, this._target);
  
  add(obj){
    if(!_used){
      _target.add(_transformer(obj));
      _used = true;
    } else {
      throw new StateError("Only one call to add allowed");
    }
  }
  
  close(){
    _target.close();
  }

}

bool _isCacheable(s){
  return s.length > 1 && ['~#','~\$','~:'].contains(s.substring(0,2));
}