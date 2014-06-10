part of restlet;

abstract class IRestModule {
  Stream<ResourceEvent> get(String route);
  Stream<ResourceEvent> post(String route);
  Stream<ResourceEvent> put(String route);
  Stream<ResourceEvent> delete(String route);
  
  String getBaseRoute();
  
  Map<Route,Resource> getResources();
}

class BaseRestModule implements IRestModule {
  Map<Route, Resource> _resources;
  String  _baseRoute;
  RouteCompiler _compiler;
  
  BaseRestModule(this._baseRoute, this._compiler) {
    _resources = <Route,Resource>{};
  }
  
  Map<Route,Resource> getResources() {
    return _resources;
  }
  
  Stream<ResourceEvent> get(String route) {
    return this.addResource(_createResource(new GETFactory(), route));
  }
  
  Stream<ResourceEvent> post(String route) {
    return this.addResource(_createResource(new POSTFactory(), route));
  }
  
  Stream<ResourceEvent> put(String route) {
    return this.addResource(_createResource(new PUTFactory(), route));
  }
  
  Stream<ResourceEvent> delete(String route) {
    return this.addResource(_createResource(new DELETEFactory(), route));
  }
  
  Stream<ResourceEvent> addResource(Resource res) {
    _compileResource(res);
    _resources[res.route] = res;
    
    return res.getDispatcher();
  }
  
  String getBaseRoute() => _baseRoute;
  
  Resource _createResource(ResourceFactory factory, String url) {
    var _url = _baseRoute + url;
    return factory.createResource(_url);
  }
  
  void _compileResource(Resource res) {
    _compiler.compile(res.route);
  } 
}