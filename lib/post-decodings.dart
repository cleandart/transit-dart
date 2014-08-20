part of transit;

class _PostDecoding{
  
  final Map<String, ReadHandler> handlers;
  final CacheLogicDecoder cache = new CacheLogicDecoder();
  
  _PostDecoding(this.handlers);
  
  decodeTop(obj){
    return decode(obj, false);
  }
  
  decode(obj, bool asMapKey){
    if (obj is List) return decodeList(obj);
    if (obj is Map) return decodeMap(obj);
    if (obj is String) return decodeString(obj, asMapKey);
    return obj;
  }
  
  decodeList(List l){
    
    if(l.length == 0)
      return [];
    
    if(l[0] == "^ "){
      Map result = {};
      int d = (l.length - 1) ~/ 2;
      for(int i = 0; i < d; i++){
        result[decode(l[2*i+1], true)] = decode(l[2*i+2], false);
      }
      return result;
    }
    
    List res = new List.from(l.map((obj)=>decode(obj, false)));
    
    if(res.length == 2 && res[0] is TransitTag)
      return decodeTagged(res[1], res[0].tag);
    
    return res;
    
  }
    
  decodeMap(Map m){
    
    if(m.length == 0)
      return {};
    
    Map res = {};
    m.forEach((key, value){
      res[decode(key, true)] = decode(value, false);
    });
    
    var k = res.keys.first;
    if(res.length == 1 && k is TransitTag)
      return decodeTagged(res.values.first, k.tag);
    
    return res;
  }
  
  decodeString(String s, bool asMapKey){
    if(s.length == 0)
      return "";
    
    if(s[0] == "^" || asMapKey || _isCacheable(s))
      s = cache.convert(s);
    
    if(s[0] == "~"){
      
      if(s[1] == "#") return new TransitTag._(s.substring(2));
      if(s[1] == "~" || s[1] == "^") return s.substring(1);   
      else return decodeTagged(s.substring(2), s[1]);
      
    } else {
      return s;
    }
  }
  
  decodeTagged(obj, String tag){
    if(handlers.containsKey(tag)){
      return handlers[tag](obj);
    } else {
      return new TransitTaggedValue(tag, obj);
    }
  }
    
   
}