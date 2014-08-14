part of transit;

class TaggedValue{
  
  final String tag;
  final rep;
  
  const TaggedValue(this.tag, this.rep);
}

class Keyword{
  
  final String key;
  
  const Keyword(this.key);
  
  String toString(){
    return key;
  }
  
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
}

class NotTransitableObjectError extends Error{
  
  final obj;
  
  NotTransitableObjectError(this.obj);
}