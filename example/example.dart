import 'package:rest_let/restlet.dart';
import 'package:route/server.dart';
import 'dart:io';

void main() {
  HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4444)
  .then((HttpServer server){
    print("Address: http://${server.address.address}:${server.port}");
    
    Router router = new Router(server);
    RestServer rest = new RestServer(router);
   
    rest.get("/api/hello")
      .listen((ResourceEvent e){
        var request = e.request;
        print("Request on");
        print(request.method);
        print(request.uri.path);
        
        request.response
          ..statusCode = 200
          ..headers
            .add('Content-Type', 'text/plain')
          ..write("Hello to")
          ..close();
      });
    
    rest.addResource(new Resource("GET", "/api/hello/:name"))
      .listen((ResourceEvent e){
        var request = e.request;
        print("Request on");
        print(request.method);
        print(request.uri.path);
        
        var route = e.route;
        var name = route.params['name'].getValue();
        
        request.response
          ..statusCode = 200
          ..headers
            .add('Content-Type', 'text/plain')
          ..write("Hello to ${name}")
          ..close();
      });
    
    rest.start();
  });
}