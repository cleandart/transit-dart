transit-dart
============

[Dart](https://www.dartlang.org/) package that implements
[Transit](http://transit-format.org) format.

Before reading this you should be familiar with the
Transit format (<http://transit-format.org>)

Usage
-----

Quick intro:

    void main(){
        var tJson = new JsonTransitCodec();
        
        tJson.encode([1, true, "It is working", new TransitKeyword("x")]);
        tJson.decode('[1, true, "It is working", "~:x"]');
        
        tJson.encoder.register(new MyClassHandler());
        tJson.encode(new MyClass("Some_Data"));
        
        tJson.decoder.register("my_tag",(data) => new MyClass(data));
        tJson.decode('["~#my_tag","Some_Data"]');
    }
    
    class MyClass{
        var data;
        MyClass(this.data);
    }
    
    class MyClassHandler extends WriteHandler<MyClass>{
        String tag(MyClass obj) => "my_tag";
        rep(MyClass obj) => obj.data;
    }
    
For more information check [latest API documentation]
(http://www.dartdocs.org/documentation/transit/latest).

Type mapping
------------

Supported built-in Dart types are:
`Null`, `bool`, `int`, `double`, `String`, `List` (as `array`),
`Map` (as `cmap`), `Set`, `Queue` (as `list`), `Uri`.

Library also provides the rest of Transit standard types:
`TransitKeyword`, `TransitSymbol`, `TransitBytes`, `TransitLink`,
`TransitUuid`, `TransitTaggedValue`.

