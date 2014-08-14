part of transit;

abstract class WriteHandler<T>{

  const WriteHandler();
  
  String tag(T obj);
  
  rep(T obj);
  
  String string_rep(T obj) => null;
  
  WriteHandler<T> verbose_handler() => this;
  
  bool _handles(obj) => obj is T;
  
  Type _type( ) => T;
}

class NullWriteHandler extends WriteHandler<Null> {

  const NullWriteHandler();
  
  String tag(Null n) => "_";

  rep(Null n) => null;
}

class StringWriteHandler extends WriteHandler<String> {

  const StringWriteHandler();
  
  String tag(String s) => 's';

  rep(String s) => s;

  String string_rep(String s) => s;
}

class BooleanWriteHandler extends WriteHandler<bool> {

  const BooleanWriteHandler();
  
  String tag(bool obj) => '?';

  rep(bool b) => b;

  String string_rep(bool b) => b?'t':'f';
}

class IntWriteHandler extends WriteHandler<int> {
  
  const IntWriteHandler();
  
  String tag(int i) => i == i.toSigned(64) ? 'i' : 'n';

  rep(int i){
      if(i == i.toSigned(64)){
        return i;
      } else {
        return i.toString();
      }
  }

  String string_rep(int i) => i.toString();
}

class KeywordWriteHandler extends WriteHandler<Keyword> {

  const KeywordWriteHandler();
  
  String tag(Keyword k) => ':';

  rep(Keyword k) => k.toString();

  String string_rep(Keyword k) => k.toString();
}

class SymbolWriteHandler extends WriteHandler<Symbol> {

  const SymbolWriteHandler();
  
  String tag(Symbol s) => '\$';

  rep(Symbol s) => s.toString();

  String string_rep(Symbol s) => s.toString();
}

class FloatWriteHandler extends WriteHandler<double> {

  const FloatWriteHandler();
  
  String tag(obj) => "f";
  
  rep(f) => f.toString();
  
  String string_rep(f) => f.toString();
}

class TimestampWriteHandler extends WriteHandler<DateTime> {

  const TimestampWriteHandler();
    
  String tag(DateTime d) => "m";

  rep(DateTime d) => d.toUtc().millisecondsSinceEpoch;
  
  String string_rep(DateTime d) => null;
  
  WriteHandler verbose_handler(){
      return const TimestringWriteHandler();
  }
}

class TimestampWriteHandlerJSON extends TimestampWriteHandler {

  const TimestampWriteHandlerJSON();
    
  rep(DateTime d) => d.toUtc().millisecondsSinceEpoch.toString();
}

class TimestringWriteHandler extends WriteHandler<DateTime> {

  const TimestringWriteHandler();
  
  String tag(DateTime d) => "t";

  rep(DateTime d) => d.toIso8601String();

  String string_rep(DateTime d) => d.toIso8601String();
}

class UriWriteHandler extends WriteHandler<Uri> {

  const UriWriteHandler();
    
  String tag(Uri u) => "r";

  rep(Uri u) => u.toString();

  String string_rep(Uri u) => u.toString();
}

class ArrayWriteHandler extends WriteHandler<List> {

  const ArrayWriteHandler();
    
  String tag(List a) => 'array';

  rep(List a) => a;
}

class SetWriteHandler extends WriteHandler<Set> {

  const SetWriteHandler();
    
  String tag(Set s) => "set";

  rep(Set s) => s.toList(growable: false);
}

class LinkedListWriteHandler extends WriteHandler<LinkedList> {

  const LinkedListWriteHandler();
    
  String tag(LinkedList s) => "list";

  rep(LinkedList s) => s.toList(growable: false);
}

class MapWriteHandler extends WriteHandler<Map> {

  const MapWriteHandler();
    
  String tag(Map m) => 'cmap';

  rep(Map m){
    List l = new List();
    for (var key in m.keys){
      l.add(key);
      l.add(m[key]);
    }
    return l;
  }
}

class LinkWriteHandler extends WriteHandler<Link> {

  const LinkWriteHandler();
    
  String tag(Link l) => "link";

  rep(Link l){
    var res = {
      "href": l.href,
      "rel": l.rel,
      "name": l.name,
    };
    if (l.render != null){
      res["render"] = l.render.toString();
    }
    if (l.prompt != null){
      res["prompt"] = l.prompt;
    }
    return new TaggedValue("map", res);
  }
}

class TaggedValueWriteHandler extends WriteHandler<TaggedValue> {

  const TaggedValueWriteHandler();
    
  String tag(TaggedValue t) => t.tag;

  rep(TaggedValue t) => t.rep;
}

class WriteHandlers extends Object {
  
  final Map<Type, WriteHandler> data;
  
  void register(WriteHandler h){
    data[h._type()] = h;
  }
  
  WriteHandler resolve(Object o){
    WriteHandler h;
    
    h = data[o.runtimeType];
    if(h != null)
      return h;
    
    for (h in data.values)
      if(h._handles(o))
        return h;
    
    throw new NotTransitableObjectError(o);
  }
  
  WriteHandlers():
    data = {};
  
  WriteHandlers.built_in():
    data = new Map.from(_BUILT_IN_INITIALIZER);
  
  static final Map<Type, WriteHandler> _BUILT_IN_INITIALIZER = {
     List: const ArrayWriteHandler(),
     Map: const MapWriteHandler(),
     String: const StringWriteHandler(),
     int: const IntWriteHandler(),
     TaggedValue: const TaggedValueWriteHandler(),
     double: const FloatWriteHandler(),
     bool: const BooleanWriteHandler(),
     Null: const NullWriteHandler(),
     Keyword: const KeywordWriteHandler(),
     Symbol: const SymbolWriteHandler(),
     DateTime: const TimestampWriteHandler(),
     Uri: const UriWriteHandler(),
     Set: const SetWriteHandler(),
     LinkedList: const LinkedListWriteHandler(),
     Link: const LinkWriteHandler(),
  };
}

