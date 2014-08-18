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

class FloatWriteHandler extends WriteHandler<double> {

  const FloatWriteHandler();
  
  String tag(obj) => "f";
  
  rep(f) => f.toString();
  
  String string_rep(f) => f.toString();
}

abstract class TimestampWriteHandler extends WriteHandler<DateTime> {

  const TimestampWriteHandler();
    
  String tag(DateTime d) => "m";
  
  WriteHandler verbose_handler(){
      return const TimestringWriteHandler();
  }
}

class JsonTimestampWriteHandler extends TimestampWriteHandler {

  const JsonTimestampWriteHandler();
    
  rep(DateTime d) => d.toUtc().millisecondsSinceEpoch.toString();
}

class MsgPackTimestampWriteHandler extends TimestampWriteHandler {

  const MsgPackTimestampWriteHandler();
    
  rep(DateTime d) => d.toUtc().millisecondsSinceEpoch;
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

abstract class UuidWriteHandler extends WriteHandler<Uuid> {

  const UuidWriteHandler();
    
  String tag(Uuid u) => "u";

  String string_rep(Uuid u) => u.toString();
}

class JsonUuidWriteHandler extends UuidWriteHandler {
  
  const JsonUuidWriteHandler();
  
  rep(Uuid u) => u.toString();
}

class MsgPackUuidWriteHandler extends UuidWriteHandler {
  
  const MsgPackUuidWriteHandler();
  
  rep(Uuid u) => [u.hi,u.lo];
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

class QueueWriteHandler extends WriteHandler<Queue> {

  const QueueWriteHandler();
    
  String tag(Queue q) => "list";

  rep(Queue q) => q.toList(growable: false);
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
  
  WriteHandlers(): data = {};
  
  WriteHandlers.built_in_json(): data = new Map.from(_BUILTINS){
    data.addAll(_BUILTINS_JSON);
  }
      
  WriteHandlers.built_in_msgPack(): data = new Map.from(_BUILTINS){
    data.addAll(_BUILTINS_MSGPACK);
  }
    
  static final Map<Type, WriteHandler> _BUILTINS = {
    List: const ArrayWriteHandler(),
    Map: const MapWriteHandler(),
    TaggedValue: const TaggedValueWriteHandler(),
    String: const StringWriteHandler(),
    int: const IntWriteHandler(),
    double: const FloatWriteHandler(),
    bool: const BooleanWriteHandler(),
    Null: const NullWriteHandler(),
    Uri: const UriWriteHandler(),
    Set: const SetWriteHandler(),
    Queue: const QueueWriteHandler(),
    Link: const LinkWriteHandler(),
  };
  
  static final Map<Type, WriteHandler> _BUILTINS_JSON = {
    DateTime: const JsonTimestampWriteHandler(),
    Uuid: const JsonUuidWriteHandler(),                                                    
  };
    
  static final Map<Type, WriteHandler> _BUILTINS_MSGPACK = {
    DateTime: const MsgPackTimestampWriteHandler(),
    Uuid: const MsgPackUuidWriteHandler(),                                                    
  };
    
    
  
}

