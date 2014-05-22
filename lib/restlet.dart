library restlet;

import 'package:route/url_pattern.dart';
import 'package:route/server.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

part './router/param.dart';
part './router/route.dart';
part './router/route_compiler.dart';
part './router/route_resolver.dart';
part './resource/resource.dart';
part './resource/resource_factory.dart';
part './resource/resource_event.dart';
part './request/rest_request.dart';

class RestServer {
  Map<Route,Resource>_resources;
  RouteCompiler _compiler;
  RouteResolver _resolver;
  
  Router _router;
  HttpServer _server;
  
  RestServer(this._server) {
    _router = new Router(_server);
    _resources = <Route,Resource>{};
    _compiler  = new RouteCompiler();
    _resolver  = new RouteResolver();
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
  
  Resource _createResource(ResourceFactory factory, String url) {
    return factory.createResource(url);
  }
  
  void _compileResource(Resource res) {
    _compiler.compile(res.route);
    _resources[res.route] = res;
  }
}