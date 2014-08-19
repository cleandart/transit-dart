part of transit;

const int _DIGITS = 44;
const int _BASE = 48;
const String _PREFIX = "^";

const _CACHE_CODING = const _CacheCodingCodec();

class _CacheCodingCodec {
  const _CacheCodingCodec ();
  
  String encode(int index) {
    int h = index ~/ _DIGITS + _BASE;
    int l = index % _DIGITS + _BASE;
    if (h == _BASE) {
      return "${_PREFIX}${new String.fromCharCode(l)}";
    } else {
      return "${_PREFIX}${new String.fromCharCode(h)}${new String.fromCharCode(l)}";
    }
  }
  
  int decode(String s) {
    if (s.length == 2) {
      return (s.codeUnitAt(1) - _BASE);
    } else {
      return (s.codeUnitAt(1) - _BASE)*_DIGITS + (s.codeUnitAt(2) - _BASE);
    }
  }
}

/**
 * Converter which stores cacheable values
 * and then is able to decode cache codes.
 */
class CacheLogicDecoder extends Converter{
  
  List data = [];
  
  /**
   * If [s] is cachecode it is decoded.
   * Otherwise [s] forwarded.
   */
  String convert(String s){
    if(s[0] == _PREFIX){
      return data[_CACHE_CODING.decode(s)];
    }
    if (s.length > 3){
      data.add(s);
    }
    return s;
  }
}

/**
 * Converter which stores cacheable values
 * and encodes repetitive ones.
 */
class CacheLogicEncoder extends Converter{
  
  int counter = 0;
  Map data = {};
  
  /**
   * If [s] is cacheable and already was
   * converted by this converter cache code
   * is returned. Otherwise [s] is forwarded.
   */
  String convert(String s){
    if (s.length > 3){
      String res = data[s];
      if(res != null){
        return res;
      }
      if (counter < _DIGITS*_DIGITS) {
        res = _CACHE_CODING.encode(counter);
        data[s] = res;
        counter++;
      }
    }
    return s;
  }
}
   

