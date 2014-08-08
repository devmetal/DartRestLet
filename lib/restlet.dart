library restlet;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:async';
import 'dart:async';

part './component/component.dart';

part 'src/router/param.dart';
part 'route.dart';
//part './router/route_compiler.dart';
//part './router/route_resolver.dart';
part 'resource.dart';
part 'src/resource/resource_factory.dart';
part 'src/resource/resource_event.dart';
part './module/rest_module.dart';
//part './module/rest_module_container.dart';
part 'src/rest/rest_request.dart';

part './component/components/rest_server.dart';

class RestLet {
  
  List<IComponent> _components;
  
  HttpServer _server;
  
  RestLet() {
    _components = <IComponent>[];
  }
  
  void addComponent(IComponent c) {
    _components.add(c);
  }
  
  void serve(InternetAddress address, int port) {
    
    _init();
    
    HttpServer.bind(address, port)
    .then((HttpServer server){
      _server = server;
      _components.forEach((e) => e.serve(server));
      print("Address: http://${server.address.address}:${server.port}");
    });
    
  }
  
  void stop() {
    _components.forEach((e) => e.stop());
    _server.close(force:true).then((_){
      print("Server closed");
      exit(0);
    });
  }
  
  void _init() {
    _components.forEach((e) => e.init());
  }
  
}