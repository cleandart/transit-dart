part of transit;

/**
 * Decoded Transit tag which wasn't associated
 * with any value.
 */
class TransitTag{
  
  final String tag;
  const TransitTag._(this.tag);
  
  String toString() => "#${tag}";
}

/**
 * Transit tag with its associated value.
 * 
 * Used to force tag encoding.
 * Can be returned from decoding when no ReadHandler
 * was specified for the given tag.
 */
class TransitTaggedValue<T>{
  
  /**
   * Tag string
   */
  final String tag;
  
  /**
   * Tag value
   */
  final T rep;
  
  const TransitTaggedValue(this.tag, this.rep);
  
  String toString() => "#${tag} ${rep}";
  
  bool operator == (TransitTaggedValue<T> that){
    return this.tag == that.tag && this.rep == that.rep;
  }
  
  int get hashCode => tag.hashCode ^ rep.hashCode;
}

/**
 * Representation of Transit Keyword type
 */
class TransitKeyword extends TransitTaggedValue<String>{
  
  const TransitKeyword(String key): super(":", key); 
}

/**
 * Representation of Transit Symbol type
 */
class TransitSymbol extends TransitTaggedValue<String>{
  
  const TransitSymbol(String val): super("\$", val); 
}

/**
 * Representation of Transit Bytes type
 */
class TransitBytes extends TransitTaggedValue<List<int>>{
  
  const TransitBytes(List<int> data): super("b", data); 
}

/**
 * Enumeration of all possible values
 * for render in Transit Link type
 */
class TransitLinkRenderType{
  
  static const LINK = const TransitLinkRenderType._("link");
  static const IMAGE = const TransitLinkRenderType._("image");
  
  static final ALL = {
     "link": LINK,
     "image": IMAGE
  };
  
  final name;
  
  const TransitLinkRenderType._(this.name);
  
  String toString() => name; 
}

/**
 * Representation of Transit Link type
 */
class TransitLink{
  Uri href;
  String rel;
  String name;
  String prompt;
  TransitLinkRenderType render;
  
  TransitLink(this.href, this.rel, this.name, {this.render: null, this.prompt: null});
  
  String toString(){
    return "Link<${href}>";
  }
  
  bool operator == (TransitLink that) =>
    this.rel == that.rel &&
    this.href == that.href &&
    this.name == that.name &&
    this.render == that.render &&
    this.prompt == that.prompt;
  
  int get hashCode => rel.hashCode ^ href.hashCode ^
    name.hashCode ^ render.hashCode ^ prompt.hashCode;
}

/**
 * Representation of Transit Uuid type
 */
class TransitUuid{
  
  /**
   * Higher 64 for bits of uuid.
   */
  final int hi;
  
  /**
   * Lower 64 for bits of uuid.
   */
  final int lo;
  
  /**
   * Create Uuid specifing hi64 and lo64.
   */
  const TransitUuid(this.hi, this.lo);
  
  /**
   * Create Uuid from string.
   */
  factory TransitUuid.parse(String s){
      
      g(int i) => "([a-fA-F0-9]{${i}})";
      RegExp r = new RegExp("^${g(8)}-${g(4)}-${g(4)}-${g(4)}-${g(12)}\$");
      
      Match m = r.firstMatch(s);
      if(m == null) throw new FormatException("${s} is not a valid uuid");
      
      v(int i) => int.parse(m.group(i),radix:16);
      var hi = v(1)*(1<<32) + v(2)*(1<<16) + v(3);
      var lo = v(4)*(1<<48) + v(5);
      
      return new TransitUuid(hi, lo);
    }
    
  String toString(){
      
    v(int val, int off, int len){
      return ((val >> (off*4)) % (1 << (len*4))).toRadixString(16).padLeft(len,"0");
    }
    return
        "${v(hi,8,8)}-${v(hi,4,4)}-${v(hi,0,4)}-${v(lo,12,4)}-${v(lo,0,12)}";
  }  
}


/**
 * Thrown when no [WriteHandler] was found for the object
 * in the [WriteHandlers].
 */
class NotTransitableObjectError extends Error{
  
  final obj;
  
  NotTransitableObjectError(this.obj);
}