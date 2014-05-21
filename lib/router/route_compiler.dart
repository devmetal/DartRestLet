part of restlet;

class RouteCompiler {
  
  String _route;
  String _static;
  String _dynamic;
    
  Map<String,Param> _params;
  List<Param> _compiled;
  
  UrlPattern _pattern;
  
  void compile(Route r) {
    _route = r.route;
    _params   = <String,Param>{};
    _compiled = <Param>[];
    
    if (!_route.contains(':')) {
      _static  = _route;
      _dynamic = "";
      _pattern = new UrlPattern(_route);
    } else {
      _getStaticPart();
      _getDynamicPart();
      _parseDynamicPart();
      _compilePattern();
    }
    
    r.pattern    = _pattern; 
    r.params     = _params;
    r.compiled   = _compiled;
    r.isCompiled = true;
  }
    
    void _getStaticPart() {
      _static = _route.substring(0,_route.indexOf(':'));
    }
    
    void _getDynamicPart() {
      _dynamic = _route.substring(_route.indexOf(':'));
    }
    
    void _parseDynamicPart() {
      _params = <String,Param>{};
      
      var regexStr = "\:([a-zA-Z_-]*)(\/){0,1}";
      var regexObj = new RegExp(regexStr);
      
      regexObj.allMatches(_dynamic).forEach((e){
        var param = e.group(1);
        _params[param] = _compileParam(param);
      });
    }
    
    Param _compileParam(String name) {
      var param = new Param<String>(name);
      _compiled.add(param);
      return param;
    }
    
    void _compilePattern() {
      var tmp = _route;
      var keys = _params.keys;
      keys.forEach((k){
        tmp = tmp.replaceAll(":${k}", "([a-zA-Z0-9]+)");
      });
      _pattern = new UrlPattern(tmp);
    }
  
}