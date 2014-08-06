part of restlet.router;

abstract class IRouteCompiler {
  void compile(Route route);
}

class RouteCompiler implements IRouteCompiler {
  
  String _route;
  String _static;
  String _dynamic;
    
  ParamMap _compiled;
  
  UrlPattern _pattern;
  
  void compile(Route route) {
    _route = route.route;
    _compiled = new ParamMap();
    
    if (!_route.contains(':')) {
      _static = _route;
      _dynamic = "";
      _pattern = new UrlPattern(_route);
    } else {
      _compileStaticPart();
      _compileDynamicPart();
      _compilePattern();
    }
    
    route.params = _compiled;
    route.pattern = _pattern;
    route.isCompiled = true;
  }
    
  void _compileStaticPart() {
    _static = _route.substring(0,_route.indexOf(':'));
  }
  
  void _compileDynamicPart() {
    _dynamic = _route.substring(_route.indexOf(':'));
    
    _parseDynamicPart();
  }
  
  void _parseDynamicPart() {
    var regexStr = "\:([a-zA-Z_-]*)(\/){0,1}";
    var regexObj = new RegExp(regexStr);
    
    regexObj.allMatches(_dynamic).forEach((e){
      var param = e.group(1);
      _compiled[param] = null;
    });
  }
  
  void _compilePattern() {
    var tmp = _route;
    var keys = _compiled.keys;
    
    keys.forEach((k){
      tmp = tmp.replaceAll(":${k.name}", "([a-zA-Z0-9]+)");
    });
    
    _pattern = new UrlPattern(tmp);
  }
  
}