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
import 'package:rest_let/restlet.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

void main() {
  HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4444)
  .then((HttpServer server){
    print("Address: http://${server.address.address}:${server.port}");
    
    RestServer rest = new RestServer(server);
    
    rest.post("/api/book")
      .listen((ResourceEvent e){
        var request = e.request;
        var body = request.body;
        
        print("Request on");
        print(request.method);
        print(request.uri.path);
        print(JSON.encode(request.body));
        
        if (body == null || !(body is Map) || 
            !body.containsKey('bookName')) {
          request
            ..setResponseStatus(403)
            ..addToResponseHeader("Content-Type", "text/html")
            ..writeToResponse("Wrong request")
            ..sendResponse();
          return;
        }
        
        getBookDatas(body['bookName'])
        .then((datas){
          request
            ..setResponseStatus(200)
            ..addToResponseHeader("Content-Type", "application/json")
            ..addAllToResponse(datas)
            ..sendResponse();
        });
      });
    
    rest.get("/api/hello")
      .listen((ResourceEvent e){
        var request = e.request;
        print("Request on");
        print(request.method);
        print(request.uri.path);
        
        request
          ..setResponseStatus(200)
          ..addToResponseHeader('Content-Type', 'text/plain')
          ..writeToResponse("Hello to")
          ..sendResponse();
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

Future&#60;Map&#60;String,dynamic&#62;&#62; getBookDatas(String name) {
    Completer&#60;Map&#60;String,dynamic&#62;&#62; c = new Completer&#60;Map&#60;String,dynamic&#62;&#62;();
    var uri = new Uri.https("www.googleapis.com", "/books/v1/volumes",{"q":name});
    print(uri.toString());
    
    var client = new HttpClient();
    client.getUrl(uri)
      .then((HttpClientRequest req) => req.close()
        .then((HttpClientResponse resp){
          UTF8.decodeStream(resp).then((sdata){
            var data = JSON.decode(sdata);
            if (data.containsKey('items')) {
              var item = data['items'][0];
              var bookDatas = {
                'title':item['volumeInfo']['title'],
                'authors':item['volumeInfo']['authors'],
                'desc':item['volumeInfo']['description'],
                'ids':item['volumeInfo']['industryIdentifiers'],
                'rating':item['volumeInfo']['averageRating']
              };
              c.complete(bookDatas);
            } else {
              c.complete({'notfound':true});
            }
          });
        }));
  return c.future;
}
</pre>

<p>
The project state is under construction, but actualy working. 
My goal: I wanna create one easy and useful REST API to Dart. 
</p>
