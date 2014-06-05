part of restlet;

class Route {
  String route;
  bool isCompiled;
  
  UrlPattern pattern;
  
  List<String> compiled;
  
  Map<String,Param> params;
  
  Route(this.route) {
    isCompiled = false;
  }
  
  bool get hasParams => params.isNotEmpty;
  bool get isStatic  => !hasParams;  
}