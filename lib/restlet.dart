library restlet;

import 'package:route/server.dart';
import 'dart:io';
import 'dart:async';
import 'resource.dart';

export 'route.dart';
export 'resource.dart';
export 'rest.dart';

class RestLet {
  
  List<Resource> _resources;
  
  HttpServer _server;
  
  Router _router;
  
  RestLet() {
    _resources = <Resource>[];
  }
  
  void serve(InternetAddress address, int port) {
    HttpServer.bind(address, port)
    .then((HttpServer server){
      _server = server;
      _router = new Router(server);
      _resources.forEach((Resource res){
        _router.serve(res.route.pattern,method: res.method)
          .listen((HttpRequest req){
            res.dispatch(req, res.route);
        });
      });
      print("Address: http://${server.address.address}:${server.port}");
    });
  }
  
  void stop() {
    _server.close(force:true).then((_){
      print("Server closed");
      exit(0);
    });
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
    _resources.add(res);
    return res.getDispatcher();
  }
  
  Resource _createResource(ResourceFactory factory, String url) {
    return factory.createResource(url);
  }
  
}