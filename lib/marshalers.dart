part of transit;



abstract class AbstractMarshaler{
  
  final WriteHandlers handlers;
  final bool forceStringKey = false;
  
  CacheLogicEncoder cache;
  var groundEmiters;
  
  AbstractMarshaler(this.handlers){
    initEmiters();
  }
  
  register(WriteHandler h){
    handlers.register(h);
  }
  
  initEmiters() {
    groundEmiters = {
      "_": this.emitNull,
      "?": this.emitBoolean,
      "s": this.emitEscapedString,
      "i": this.emitInt,
      "d": this.emitFloat,
      "b": this.emitBytes,
      "array": this.emitArray,
      "map": this.emitMap,
      "'": this.emitQuoted,
    };
  }
  
  emitArray(List l, asMapKey){
    if(asMapKey && forceStringKey) throw new ArgumentError("Array is a key");
    return new List.from(l.map((obj)=>this.marshal(obj,false)));
  }
  
  emitMap(Map m, asMapKey){
    if(asMapKey && forceStringKey) throw new ArgumentError("Map is a key");
    var result = {};
    m.forEach((key,value){
      result[this.marshal(key,true)] = 
          this.marshal(value,false);
    });
    return result;
  }
  
  emitQuoted(obj, asMapKey) => emitTagged("'",obj, asMapKey);
  
  emitString(String s, asMapKey){
    if (asMapKey || _isCacheable(s))
      return cache.convert(s);
    else
      return s; 
  }
  
  emitEscapedString(String s, asMapKey){
    if (s.length > 0 && (s[0] == '~' || s[0] == '^' || s[0] == '`'))
        return emitString('~${s}', asMapKey);
    return emitString(s, asMapKey);
  }
    
  emitInt(int i, asMapKey) => i;
  
  emitFloat(double d, asMapKey) => d;
  
  emitNull(Null n, asMapKey) => null;
  
  emitBoolean(bool b, asMapKey) => b;
  
  emitBytes(obj, asMapKey) => "~b${CryptoUtils.bytesToBase64(obj)}";
  
  emitTagged(tag, rep, asMapKey){
    if(asMapKey && forceStringKey)
      throw new ArgumentError("Composed tag is a key");
    return [emitString("~#${tag}", asMapKey),
      marshal(rep, false)];
  }
  
  marshalTop(obj){
    cache = new CacheLogicEncoder();
    WriteHandler handler = handlers.resolve(obj);
    String tag = handler.tag(obj);
    if(tag.length == 1) return emitQuoted(obj, false);
    else return marshal(obj, false);
  }
  
  marshal(obj, asMapKey){
    WriteHandler handler = handlers.resolve(obj);
    String tag = handler.tag(obj);
    
    var rep = handler.rep(obj);
    
    var emitGround = groundEmiters[tag];
    if(emitGround != null)
      return emitGround(rep, asMapKey);
    
    if(tag.length != 1){
      if(asMapKey) throw new ArgumentError("Non-ground is a key");
      return emitTagged(tag, rep, asMapKey);
    }
    
    if(rep is String){
      return emitString("~${tag}${rep}", asMapKey);
    }
    
    if(forceStringKey && asMapKey){
      String str_rep = handler.string_rep(obj);
      if(str_rep == null) throw new ArgumentError("Non-string is a key");
      return emitString("~${tag}${str_rep}", asMapKey);
    }
    
    return emitTagged(tag, rep, asMapKey);
  }
  
}

abstract class AbstractJsonMarshaler extends AbstractMarshaler {
  
  final bool forceStringKey = true;
  
  AbstractJsonMarshaler(WriteHandlers h): super(h);
  
  emitInt(int i, asMapKey){
    if(asMapKey || i != i.toSigned(53))
      return "~i${i}";
    return i;
  }
    
  emitFloat(double d, asMapKey) => asMapKey ? d.toString() : d;
  
  emitNull(Null n, asMapKey) => asMapKey ? "~_" : null;
  
  emitBoolean(bool b, asMapKey) => asMapKey ? "~?${b?'t':'f'}" : b;
  
}

class MsgPackMarshaler extends AbstractMarshaler {
  
  MsgPackMarshaler(WriteHandlers h): super(h);
}

class JsonMarshaler extends AbstractJsonMarshaler {
  
  JsonMarshaler(WriteHandlers h): super(h);
  
  emitMap(Map m, asMapKey){
    if(asMapKey) throw new ArgumentError("Map is a key");
    var result = ["^ "];
    m.forEach((key,value){
      result.add(this.marshal(key,false));
      result.add(this.marshal(value,false));
    });
    return result;
  }
}

class VerboseJsonMarshaler extends AbstractJsonMarshaler {
  
  VerboseJsonMarshaler(WriteHandlers h): super(h){
    handlers.data.forEach((Type key, WriteHandler value) {
      handlers.data[key] = value.verbose_handler();
    });
  }
  
  register(WriteHandler h){
      handlers.register(h.verbose_handler());
  }
  
  emitTagged(tag, rep, asMapKey){
    if (asMapKey) throw new ArgumentError("Composed tag is a key");
    return {emitString("~#${tag}", asMapKey):
      marshal(rep, false)};
    }
  
  emitString(String s, asMapKey){
    return s;
  }
}
