import 'package:unittest/unittest.dart';
import 'package:rest_let/route.dart';

main() {
  
  Route r;
  
  group('RouterTest',(){
    
    setUp(() => r = new Route.fromString("/api/hello/:name"));
    
    test('Initialize',(){
      expect(r, new isInstanceOf<Route>());
    });
    
    test('CompileParts',(){
      List<String> parts = r.getParts();
      expect(parts.length,equals(3));
      expect(parts,equals(['/api','/hello','/:name']));
    });
    
    test('Matching',(){
      RouteMatch routeMatch = r.match("/api/hello/Adam");
      expect(routeMatch,isNotNull);
      expect(routeMatch["name"],equals("Adam"));
      
    });
  });
}