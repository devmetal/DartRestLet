library example;

import 'dart:io';
import 'dart:convert';

final String PATH_TO_WEB = "../web";

void main() {
  HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4444)
  .then((HttpServer server){
    print("Server started!");
    print("Address: http://${server.address.address}:${server.port}");
    
    Router router = new Router(server);
    RestServer rest = new RestServer(router);
    
    rest.addResource(new Resource("GET", "/api/hello"))
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
    
    rest.addResource(new Resource("POST","/api/hello/:id"))
      .listen((ResourceEvent e){
        var request = e.request;
        var route = e.route;
        print("Request on");
        print(request.method);
        print(request.uri.path);
        
        if (request.contentLength == -1) {
          request.response
            ..statusCode = 200
            ..write('')
            ..close();
        } else {
          UTF8.decodeStream(request)
            .then((data){
            var json = JSON.decode(data);
            var name = json['name'];
            var age  = json['age'];
            var id = route.params['id'].getValue();
            request.response
              ..statusCode = 200
              ..headers
                .add('Content-Type', 'application/json')
              ..write(JSON.encode(
                      {'return':{
                        'name':name,
                        'age':age,
                        'id':id}
                      }))
              ..close();
          });
        }
      });
    
    rest.start();
  });
}