part of restlet;

class RouteResolver {
  RouteResolver();
  
  void resolve(Route r, String path) {
    List<String> parsed   = r.pattern.parse(path);
    List<String> compiled = r.compiled;
    
    parsed.forEach((e){
      var i = parsed.indexOf(e);
      //compiled[i].setValue(e);
    });
  }
}