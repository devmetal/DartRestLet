library restlet.router;

import 'package:route/url_pattern.dart';

part './src/router/param.dart';
part './src/router/match.dart';

class Route {
  String _routeString;
  
  UrlPattern _pattern;
  
  List<String> _routeParts;
  
  String _parameterRegexString = r"\:([a-zA-Z_-]*)(\/){0,1}";
  
  RegExp _parameterRegexObject = null;
  
  Route.fromString(String routeString) {
    _routeParts = <String>[];
    _parameterRegexObject = new RegExp(_parameterRegexString);
    _routeString = routeString;
    
    _compile();
  }
  
  RouteMatch match(String route) {
    if (_pattern.matches(route)) {
      return new RouteMatch.fromRouteMatches(_pattern.allMatches(route),_routeParts);
    } else {
      return null;
    }
  }
  
  List<String> getParts() {
    return _routeParts;
  }
  
  void _compile() {
    if (_hasRouteParameters()) {
      _compileRouteParameterParts();
    }
    
    _generateUrlPattern();
  }
  
  bool _hasRouteParameters() => 
      _parameterRegexObject.hasMatch(_routeString);
  
  void _compileRouteParameterParts() => 
      _parameterRegexObject.allMatches(_routeString).forEach( (m) => _routeParts.add(m.group(1)) );
  
  void _generateUrlPattern() {
    var tmp = _routeString;
    if (_routeParts.isNotEmpty) {
      _routeParts.forEach((e){
        tmp = tmp.replaceAll(":${e}", "([a-zA-Z0-9]+)");
      });
    }
    _pattern = new UrlPattern(tmp);
  }
  
  UrlPattern get pattern => _pattern;
}