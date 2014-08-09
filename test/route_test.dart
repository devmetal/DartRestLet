import 'package:unittest/unittest.dart';
import 'package:rest_let/route.dart';

main() {
  
  Route r;
  
  group('RouterTest',(){
    
    setUp(() => r = new Route.fromString("/api/hello/:name/:age"));
    
    test('Initialize',(){
      expect(r, new isInstanceOf<Route>());
    });
    
    test('CompileParts',(){
      List<String> parts = r.getParts();
      expect(parts.length,equals(2));
      expect(parts,equals(['name','age']));
    });
    
    test('Matches',(){
      RouteMatch match = r.match("/api/hello/Adam/23");
      expect(match['name'],equals('Adam'));
      expect(match['age'], equals('23'));
    });
  });
}