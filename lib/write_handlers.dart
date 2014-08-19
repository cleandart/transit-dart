part of transit;


/**
 * Superclass for custom WriteHandlers, that allows
 * encoding own types to Transit.
 * 
 * The type handler is used for MUST be specified
 * as a generics parameter. If the type is `dynamic`,
 * handler matches all objects - behaves like a default.
 */
abstract class WriteHandler<T>{

  const WriteHandler();
  
  /**
   * Returns tag object is encoded with
   */
  String tag(T obj);
  
  /**
   * Returns transit-encodable representation of object
   */
  rep(T obj);
  
  /**
   * Returns string transit representation of object
   * or `null` if no such representation exists.
   * Used for map keys with one-char tags.
   */
  String string_rep(T obj) => null;
  
  /**
   * Returns alternative handler which encodes to human
   * readable form. By default returns `this`.
   */
  WriteHandler<T> verbose_handler() => this;
  
  bool _handles(obj) => obj is T;
  
  Type _type( ) => T;
}

class _NullWriteHandler extends WriteHandler<Null> {

  const _NullWriteHandler();
  
  String tag(Null n) => "_";

  rep(Null n) => null;
}

class _StringWriteHandler extends WriteHandler<String> {

  const _StringWriteHandler();
  
  String tag(String s) => 's';

  rep(String s) => s;

  String string_rep(String s) => s;
}

class _BooleanWriteHandler extends WriteHandler<bool> {

  const _BooleanWriteHandler();
  
  String tag(bool obj) => '?';

  rep(bool b) => b;

  String string_rep(bool b) => b?'t':'f';
}

class _IntWriteHandler extends WriteHandler<int> {
  
  const _IntWriteHandler();
  
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

class _FloatWriteHandler extends WriteHandler<double> {

  const _FloatWriteHandler();
  
  String tag(obj) => "f";
  
  rep(f) => f.toString();
  
  String string_rep(f) => f.toString();
}

abstract class _TimestampWriteHandler extends WriteHandler<DateTime> {

  const _TimestampWriteHandler();
    
  String tag(DateTime d) => "m";
  
  WriteHandler verbose_handler(){
      return const _TimestringWriteHandler();
  }
}

class _JsonTimestampWriteHandler extends _TimestampWriteHandler {

  const _JsonTimestampWriteHandler();
    
  rep(DateTime d) => d.toUtc().millisecondsSinceEpoch.toString();
}

class _MsgPackTimestampWriteHandler extends _TimestampWriteHandler {

  const _MsgPackTimestampWriteHandler();
    
  rep(DateTime d) => d.toUtc().millisecondsSinceEpoch;
}

class _TimestringWriteHandler extends WriteHandler<DateTime> {

  const _TimestringWriteHandler();
  
  String tag(DateTime d) => "t";

  rep(DateTime d) => d.toIso8601String();

  String string_rep(DateTime d) => d.toIso8601String();
}

class _UriWriteHandler extends WriteHandler<Uri> {

  const _UriWriteHandler();
    
  String tag(Uri u) => "r";

  rep(Uri u) => u.toString();

  String string_rep(Uri u) => u.toString();
}

abstract class _UuidWriteHandler extends WriteHandler<TransitUuid> {

  const _UuidWriteHandler();
    
  String tag(TransitUuid u) => "u";

  String string_rep(TransitUuid u) => u.toString();
}

class _JsonUuidWriteHandler extends _UuidWriteHandler {
  
  const _JsonUuidWriteHandler();
  
  rep(TransitUuid u) => u.toString();
}

class _MsgPackUuidWriteHandler extends _UuidWriteHandler {
  
  const _MsgPackUuidWriteHandler();
  
  rep(TransitUuid u) => [u.hi,u.lo];
}

class _ArrayWriteHandler extends WriteHandler<List> {

  const _ArrayWriteHandler();
    
  String tag(List a) => 'array';

  rep(List a) => a;
}

class _SetWriteHandler extends WriteHandler<Set> {

  const _SetWriteHandler();
    
  String tag(Set s) => "set";

  rep(Set s) => s.toList(growable: false);
}

class _QueueWriteHandler extends WriteHandler<Queue> {

  const _QueueWriteHandler();
    
  String tag(Queue q) => "list";

  rep(Queue q) => q.toList(growable: false);
}

class _MapWriteHandler extends WriteHandler<Map> {

  const _MapWriteHandler();
    
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

class _LinkWriteHandler extends WriteHandler<TransitLink> {

  const _LinkWriteHandler();
    
  String tag(TransitLink l) => "link";

  rep(TransitLink l){
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
    return new TransitTaggedValue("map", res);
  }
}

class _TaggedValueWriteHandler extends WriteHandler<TransitTaggedValue> {

  const _TaggedValueWriteHandler();
    
  String tag(TransitTaggedValue t) => t.tag;

  rep(TransitTaggedValue t) => t.rep;
}

/**
 * A collection of [WriteHandler]s. For each type
 * at most one handler can be registered.
 * 
 * Allows to find correct handler for a given object.
 */
class WriteHandlers extends Object {
  
  /**
   * Registered handlers
   */
  final Map<Type, WriteHandler> data;
  
  /**
   * Register new handler. Replaces old one
   * of the same type.
   */
  void register(WriteHandler h){
    data[h._type()] = h;
  }
  
  /**
   * Finds handler for [o].
   * 
   * If [o] has same type as one of the registered handlers,
   * this handler is returned. Otherwise, first registered
   * handler covering the supertype of [o] is used.
   * 
   * Throws [NotTransitableObjectError] if no suitable
   * handler was found.
   */
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
  
  /**
   * Creates empty WriteHandlers
   */
  WriteHandlers(): data = {};
  
  /**
   * Creates default WriteHandlers for JSON
   */
  WriteHandlers.built_in_json(): data = new Map.from(_BUILTINS){
    data.addAll(_BUILTINS_JSON);
  }
  
  /**
   * Creates default WriteHandlers for MsgPack
   */
  WriteHandlers.built_in_msgPack(): data = new Map.from(_BUILTINS){
    data.addAll(_BUILTINS_MSGPACK);
  }
    
  static final Map<Type, WriteHandler> _BUILTINS = {
    List: const _ArrayWriteHandler(),
    Map: const _MapWriteHandler(),
    TransitTaggedValue: const _TaggedValueWriteHandler(),
    String: const _StringWriteHandler(),
    int: const _IntWriteHandler(),
    double: const _FloatWriteHandler(),
    bool: const _BooleanWriteHandler(),
    Null: const _NullWriteHandler(),
    Uri: const _UriWriteHandler(),
    Set: const _SetWriteHandler(),
    Queue: const _QueueWriteHandler(),
    TransitLink: const _LinkWriteHandler(),
  };
  
  static final Map<Type, WriteHandler> _BUILTINS_JSON = {
    DateTime: const _JsonTimestampWriteHandler(),
    TransitUuid: const _JsonUuidWriteHandler(),                                                    
  };
    
  static final Map<Type, WriteHandler> _BUILTINS_MSGPACK = {
    DateTime: const _MsgPackTimestampWriteHandler(),
    TransitUuid: const _MsgPackUuidWriteHandler(),                                                    
  };
    
    
  
}

