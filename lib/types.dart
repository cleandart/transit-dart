part of transit;

class TaggedValue<T>{
  
  final String tag;
  final T rep;
  
  const TaggedValue(this.tag, this.rep);
  
  String toString() => "#${tag} ${rep}";
  
  bool operator == (TaggedValue<T> that){
    print(this.rep == that.rep);
    return this.tag == that.tag && this.rep == that.rep;
  }
  
  int get hashCode => tag.hashCode ^ rep.hashCode;
}

class Keyword extends TaggedValue<String>{
  
  const Keyword(String key): super(":", key); 
}

class TSymbol extends TaggedValue<String>{
  
  const TSymbol(String val): super("\$", val); 
}

class Bytes extends TaggedValue<List<int>>{
  
  const Bytes(List<int> data): super("b", data); 
}

class LinkRenderType{
  
  static const LINK = const LinkRenderType._("link");
  static const IMAGE = const LinkRenderType._("image");
  
  static final ALL = {
     "link": LINK,
     "image": IMAGE
  };
  
  final name;
  
  const LinkRenderType._(this.name);
  
  String toString() => name; 
}

class Link{
  Uri href;
  String rel;
  String name;
  String prompt;
  LinkRenderType render;
  
  Link(this.href, this.rel, this.name, {this.render: null, this.prompt: null});
  
  String toString(){
    return "Link<${href}>";
  }
  
  bool operator == (Link that) =>
    this.rel == that.rel &&
    this.href == that.href &&
    this.name == that.name &&
    this.render == that.render &&
    this.prompt == that.prompt;
  
  int get hashCode => rel.hashCode ^ href.hashCode ^
    name.hashCode ^ render.hashCode ^ prompt.hashCode;
}

class Uuid{
  
  final int hi;
  final int lo;
  
  const Uuid(this.hi, this.lo);
  
  factory Uuid.parse(String s){
      
      g(int i) => "([a-fA-F0-9]{${i}})";
      RegExp r = new RegExp("^${g(8)}-${g(4)}-${g(4)}-${g(4)}-${g(12)}\$");
      
      Match m = r.firstMatch(s);
      if(m == null) throw new FormatException("${s} is not a valid uuid");
      
      v(int i) => int.parse(m.group(i),radix:16);
      var hi = v(1)*(1<<32) + v(2)*(1<<16) + v(3);
      var lo = v(4)*(1<<48) + v(5);
      
      return new Uuid(hi, lo);
    }
    
  String toString(){
      
    v(int val, int off, int len){
      return ((val >> (off*4)) % (1 << (len*4))).toRadixString(16).padLeft(len,"0");
    }
    return
        "${v(hi,8,8)}-${v(hi,4,4)}-${v(hi,0,4)}-${v(lo,12,4)}-${v(lo,0,12)}";
  }  
}

class NotTransitableObjectError extends Error{
  
  final obj;
  
  NotTransitableObjectError(this.obj);
}