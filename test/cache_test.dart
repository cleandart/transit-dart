part of test;

testCache() => group("Cache", () {
  
  group("Encode", () {
      
    test("Simple",(){
      var C = new CacheLogicEncoder();
      expect(C.convert("aaaa"),equals("aaaa"));
      expect(C.convert("aaaa"),equals("^0"));        
    });
    
    test("Multiple",(){
      var C = new CacheLogicEncoder();
      expect(C.convert("aaaa"),equals("aaaa"));
      expect(C.convert("bbbb"),equals("bbbb"));
      expect(C.convert("bbbb"),equals("^1"));
      expect(C.convert("cccc"),equals("cccc"));
      expect(C.convert("bbbb"),equals("^1"));
      expect(C.convert("aaaa"),equals("^0"));
      expect(C.convert("cccc"),equals("^2"));
    });
    
    test("Short",(){
      var C = new CacheLogicEncoder();
      expect(C.convert("aaa"),equals("aaa"));
      expect(C.convert("aaaa"),equals("aaaa")); 
      expect(C.convert("aaa"),equals("aaa"));
      expect(C.convert("aaaa"),equals("^0"));
    });
    
    test("Many",(){
      var C = new CacheLogicEncoder();
      for(int i = 48; i < 92; i++){
        expect(C.convert("aaaa$i"),equals("aaaa$i"));
        expect(C.convert("aaaa$i"),equals("^${new String.fromCharCode(i)}"));
      }
      expect(C.convert("bbbb"),equals("bbbb")); 
      expect(C.convert("bbbb"),equals("^10"));
    });
        
  });
  
  group("Decode", () {
    
    test("Simple",(){
      var C = new CacheLogicDecoder();
      expect(C.convert("aaaa"),equals("aaaa"));
      expect(C.convert("^0"),equals("aaaa"));        
    });
    
    test("Multiple",(){
      var C = new CacheLogicDecoder();
      expect(C.convert("aaaa"),equals("aaaa"));
      expect(C.convert("bbbb"),equals("bbbb"));
      expect(C.convert("^1"),equals("bbbb"));
      expect(C.convert("cccc"),equals("cccc"));
      expect(C.convert("^1"),equals("bbbb"));
      expect(C.convert("^0"),equals("aaaa"));
      expect(C.convert("^2"),equals("cccc"));
    });
    
    test("Short",(){
      var C = new CacheLogicDecoder();
      expect(C.convert("aaa"),equals("aaa"));
      expect(C.convert("aaaa"),equals("aaaa"));
      expect(C.convert("aaa"),equals("aaa"));
      expect(C.convert("^0"),equals("aaaa"));
    });
    
    test("Many",(){
      var C = new CacheLogicDecoder();
      for(int i = 48; i < 92; i++){
        expect(C.convert("aaaa$i"),equals("aaaa$i"));
        expect(C.convert("^${new String.fromCharCode(i)}"),equals("aaaa$i"));
      }
      expect(C.convert("bbbb"),equals("bbbb")); 
      expect(C.convert("^10"),equals("bbbb"));
    });
              
  });
    
});