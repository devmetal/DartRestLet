part of restlet;

class RouteResolver {
  RouteResolver();
  
  void resolve(Route r, String path) {
    List<String> parsed   = r.pattern.parse(path);
    
    parsed.forEach((e){
      var index = parsed.indexOf(e);
      var key   = r.params.getKeyByIndex(index);
      
      Param<String> p = new Param<String>(key.name,e);
      
      r.params[key.name] = p;
    });
  }
}