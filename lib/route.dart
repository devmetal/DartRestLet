library restlet.router;

part './src/router/param.dart';
part './src/router/compiler.dart';
part './src/router/match.dart';

class Route {
  String routeString;
  
  List<Param<String,dynamic>> _parameters;
  List<String> _routeParts;
  
  Route.fromString(String routeString) {
    _parameters = <Param<String,dynamic>>[];
    _routeParts = <String>[];
    
    this.routeString = routeString;
    _compile();
  }
  
  RouteMatch match(String route) {
    List<String> parts = route.split("/");
    if (parts.length != _routeParts.length) {
      return null;
    }
  }
  
  List<String> getParts() {
    return _routeParts;
  }
  
  void _compile() {
    _compileParts();
  }
  
  void _compileParts() {
    var regexStr = r"/([a-zA-Z_:]*)";
    var regexObj = new RegExp(regexStr);
    regexObj.allMatches(this.routeString).forEach( (m) => _routeParts.add(m.group(0)) );
  }
}