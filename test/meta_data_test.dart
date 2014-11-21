import 'package:unittest/unittest.dart';
import 'package:rest_let/application.dart';

@module('/apiv1')
class Foo {
  @action('/hello','GET')
  helloHandler() => print("Request handled");
  
  @action('/hello/:name','GET')
  requestHandler(name) => print("Incoming data: ${name}"); 
}

class Bar {
  invalidHandler() => print("Request handled");
}

main() {
  group('MetadataTest',(){
    test('Test Valid Module',(){
      MetadataParser parser = new MetadataParser(Foo);
      expect(parser.baseRoute(),equals('/apiv1'));
      var actions = parser.actions();
      expect(actions.length,equals(2));
      var action1 = actions[0];
      var action2 = actions[1];
      
      expect(action1.method,equals('GET'));
      expect(action2.method,equals('GET'));
      expect(action1.route,equals('/apiv1/hello'));
      expect(action2.route,equals('/apiv1/hello/:name'));
      expect(action1.symbol,equals(#helloHandler));
      expect(action2.symbol,equals(#requestHandler));
    });
    
    test('Test invalid module',(){
      expect(() => new MetadataParser(Bar),
          throwsA(new isInstanceOf<String>()));
    });
  });
}