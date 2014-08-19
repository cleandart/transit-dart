part of transit;



abstract class _AbstractPreEncoding{
  
  final WriteHandlers handlers;
  final bool forceStringKey = false;
  final CacheLogicEncoder cache;
  
  var groundEmiters;
  
  _AbstractPreEncoding(this.handlers): cache = new CacheLogicEncoder(){
    initEmiters();
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
    return new List.from(l.map((obj)=>this.encode(obj,false)));
  }
  
  emitMap(Map m, asMapKey){
    if(asMapKey && forceStringKey) throw new ArgumentError("Map is a key");
    var result = {};
    m.forEach((key,value){
      result[this.encode(key,true)] = 
          this.encode(value,false);
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
      encode(rep, false)];
  }
  
  encodeTop(obj){
    WriteHandler handler = handlers.resolve(obj);
    String tag = handler.tag(obj);
    if(tag.length == 1) return emitQuoted(obj, false);
    else return encode(obj, false);
  }
  
  encode(obj, asMapKey){
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

abstract class _AbstractJsonPreEncoding extends _AbstractPreEncoding {
  
  final bool forceStringKey = true;
  
  _AbstractJsonPreEncoding(WriteHandlers h): super(h);
  
  emitInt(int i, asMapKey){
    if(asMapKey || i != i.toSigned(53))
      return "~i${i}";
    return i;
  }
    
  emitFloat(double d, asMapKey) => asMapKey ? d.toString() : d;
  
  emitNull(Null n, asMapKey) => asMapKey ? "~_" : null;
  
  emitBoolean(bool b, asMapKey) => asMapKey ? "~?${b?'t':'f'}" : b;
  
}

class _MsgPackPreEncoding extends _AbstractPreEncoding {
  
  _MsgPackPreEncoding(WriteHandlers h): super(h);
}

class _JsonPreEncoding extends _AbstractJsonPreEncoding {
  
  _JsonPreEncoding(WriteHandlers h): super(h);
  
  emitMap(Map m, asMapKey){
    if(asMapKey) throw new ArgumentError("Map is a key");
    var result = ["^ "];
    m.forEach((key,value){
      result.add(this.encode(key,true));
      result.add(this.encode(value,false));
    });
    return result;
  }
}

class _VerboseJsonPreEncoding extends _AbstractJsonPreEncoding {
  
  _VerboseJsonPreEncoding(WriteHandlers h): super(h){
    handlers.data.forEach((Type key, WriteHandler value) {
      handlers.data[key] = value.verbose_handler();
    });
  }
  
  emitTagged(tag, rep, asMapKey){
    if (asMapKey) throw new ArgumentError("Composed tag is a key");
    return {emitString("~#${tag}", asMapKey):
      encode(rep, false)};
    }
  
  emitString(String s, asMapKey){
    return s;
  }
}
