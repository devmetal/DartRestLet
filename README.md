<h1>Dart RESTLet</h1>
<p>
This is a very simple dart package for restful webservices.
</p>
<p>
This API based on <a href="https://github.com/justinfagnani/route">route</a> project.
I wanna create api like expressjs, and i hope is useful.
</p>
<h2>Example</h2>
<pre>
library example;

import 'restlet.dart';
import 'package:route/server.dart';
import 'dart:io';

void main() {
  HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4444)
  .then((HttpServer server){
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
    
    rest.start();
  });
}
</pre>

<p>
The project state is under construction, but actualy working. 
My goal: I wanna create one easy and useful REST API to Dart. 
</p>
