part of restlet;

class RestServer implements IComponent {
  //RouteCompiler _compiler;
  //RouteResolver _resolver;
  
  //Router _router;
  
  String _baseRoute;
  Map<String, IRestModule> _modules;
  BaseRestModule _baseModule;
  
  RestServer(this._baseRoute) {
    //_compiler  = new RouteCompiler();
    //_resolver  = new RouteResolver();
    
    _modules    = <String,IRestModule>{};
    //_baseModule = new BaseRestModule(getBaseRoute(), _compiler);
    
    this.add(_baseModule);
  }
  
  @override
  void init() {
  }

  @override
  void serve(HttpServer server) {
    /*_router = new Router(server);
    
    _modules.forEach((moduleRoute,module){
      module.getResources().forEach((route,resource){
        print(route.route);
        print(route.pattern.toString());
        _router.serve(route.pattern,method:resource.method)
        .listen((HttpRequest req){
          _resolver.resolve(route, req.uri.path);
          resource.dispatch(req,route);
        });  
      });
    });*/
    
  }

  @override
  void stop() {
    //_router = null;
  }
  
  @override
  void add(IRestModule module) {
    var k = module.getBaseRoute();
    this._modules[k] = module;
  }

  @override
  String getBaseRoute() {
    return this._baseRoute;
  }

  @override
  IRestModule getModule(String route) {
    if (_modules.containsKey(route)) {
      return _modules[route];
    } else {
      return null;
    }
  }

  @override
  bool rem(IRestModule module) {
    var k = module.getBaseRoute();
    if (_modules.containsKey(k)) {
      _modules.remove(k);
      return true;
    } else {
      return false;
    }
  }
  
  @override
  Stream<ResourceEvent> get(String route) {
    return _baseModule.get(route);
  }
  
  @override
  Stream<ResourceEvent> post(String route) {
    return _baseModule.post(route);
  }
  
  @override
  Stream<ResourceEvent> put(String route) {
    return _baseModule.put(route);
  }
  
  @override
  Stream<ResourceEvent> delete(String route) {
    return _baseModule.delete(route);
  }

  @override
  Map<Route, Resource> getResources() {
    return _baseModule.getResources();
  }
}