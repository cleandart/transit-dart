part of test;

testCache() => group("Cache", () {
  
  group("Coding", () {
    var IDs = [0, 1, 10, 43, 44, 50, 100];
    var STRs = ["^0","^1","^:","^[","^10","^16","^2<"];
    
    group("Encode", () {
      for(int i = 0; i < IDs.length; i++){
        test(IDs[i].toString(), () {
          expect(CACHE_CODING.encode(IDs[i]),equals(STRs[i]));
        });
      }
    });
    
    group("Decode", () {
      for(int i = 0; i < STRs.length; i++){
        test(STRs[i], () {
          expect(CACHE_CODING.decode(STRs[i]),equals(IDs[i]));
        });
      }
    });
    
  });
  
  group("Logic", () {
    
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
    });
    
  });
    
});