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

class MsgPackPreEncoder extends PreEncoder{
  
  final MsgPackMarshaler marshaler =
      new MsgPackMarshaler(new WriteHandlers.built_in_msgPack());

}

class JsonPreEncoder extends PreEncoder{
  
  final JsonMarshaler marshaler =
      new JsonMarshaler(new WriteHandlers.built_in_json());

}

class VerboseJsonPreEncoder extends PreEncoder{
  
  final VerboseJsonMarshaler marshaler =
      new VerboseJsonMarshaler(new WriteHandlers.built_in_json());

}


