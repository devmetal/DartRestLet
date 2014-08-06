library restlet;

import 'package:route/url_pattern.dart';
import 'package:route/server.dart';
import 'dart:io';
import 'dart:async';

part 'router/param.dart';
part 'router/route.dart';
part 'router/route_compiler.dart';
part 'router/route_resolver.dart';

class RestServer {
  Map<Route,Resource>_resources;
  RouteCompiler _compiler;
  RouteResolver _resolver;
  Router _router;
  
  RestServer(this._router) {
    _resources = <Route,Resource>{};
    _compiler  = new RouteCompiler();
    _resolver  = new RouteResolver();
  }
  
  Stream<ResourceEvent> addResource(Resource res) {
    Route route = res.route;
    _compiler.compile(route);
    _resources[route] = res;
    
    return res.getDispatcher();
  }
  
  void start() {
    _resources.forEach((route,resource){
      _router.serve(route.pattern,method:resource.method)
        .listen((HttpRequest req){
          _resolver.resolve(route, req.uri.path);
          resource.dispatch(req,route);
        });
    });
  }
}



/**
 * 
 */
class Resource {
  Route route;
  String method;
  
  StreamController<ResourceEvent> _dsStream;
  
  Stream<ResourceEvent> getDispatcher() {
    return _dsStream.stream;
  }

  Resource(this.method, String url) {
    route = new Route(url);
    _dsStream = new StreamController<ResourceEvent>();
  }
  
  void dispatch(HttpRequest req,Route route) {
    _dsStream.add(new ResourceEvent(req,route));
  }
}

class ResourceEvent {
  HttpRequest request;
  Route route;
  ResourceEvent(this.request,this.route);
}