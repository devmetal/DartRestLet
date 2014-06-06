part of restlet;

class Route {
  String route;
  
  bool isCompiled;
  
  UrlPattern pattern;
  
  ParamMap params;
  
  Route(this.route) {
    isCompiled = false;
  }
  
  bool get hasParams => params.isNotEmpty;
  bool get isStatic  => !hasParams;  
}