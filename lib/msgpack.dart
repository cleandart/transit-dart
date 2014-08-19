part of transit;

class MsgPackEncoder extends Converter<dynamic, List<int>>{
  
  List<int> convert(obj){
    Packer packer = new Packer();
    return packer.pack(obj);
  }
}

class MsgPackDecoder extends Converter<List<int>, dynamic>{
  
  convert(List<int> list){
    Uint8List data = new Uint8List.fromList(list);
    Unpacker unpacker = new Unpacker(data.buffer);
    return unpacker.unpack();
  }
}

