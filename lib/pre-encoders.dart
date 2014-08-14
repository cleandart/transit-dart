part of transit;

abstract class PreEncoder extends Converter {

  AbstractMarshaler get marshaler;

  convert(obj) {
    return marshaler.marshalTop(obj);
  }

  register(WriteHandler h) {
    marshaler.register(h);
  }

  Sink startChunkedConversion(Sink s) {
    return new _OneChunkTransformer(this.convert, s);
  }
}

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

class MsgPackPreEncoder extends PreEncoder{
  
  final MsgPackMarshaler marshaler =
      new MsgPackMarshaler(new WriteHandlers.built_in());

}

class JsonPreEncoder extends PreEncoder{
  
  final JsonMarshaler marshaler =
      new JsonMarshaler(new WriteHandlers.built_in());

}

class VerboseJsonPreEncoder extends PreEncoder{
  
  final VerboseJsonMarshaler marshaler =
      new VerboseJsonMarshaler(new WriteHandlers.built_in());

}


