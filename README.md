Dart RESTLet
============

This is a very simple dart package for restful webservices.
We can create a simple RESTful http server.

This API based on [route](https://github.com/justinfagnani/route) project.
I wanna create api like expressjs, and i hope is useful.

Basic example:
--------------

```dart
import 'package:rest_let/restlet.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

void main() {
  
  RestLet r = new RestLet();
  
  r.get("/hello/:name/:male")
    .listen((ResourceEvent e){
      var request = e.request;
      
      print("Request on");
      print(request.method);
      print(request.httpRequest.uri.path);
      
      var routeMatch = e.match;
      var name = routeMatch["name"];
      var male = routeMatch["male"];
      
      request.restResponse
        ..statusCode = 200
        ..contentTypeTextPlain()
        ..httpResponse
          .write("Hello to ${(male == "1"?"Mr.":"Ms.")} ${name}")
        ..send();
    });
  
  r.post("/book")
    .listen((ResourceEvent e){
      var request = e.request;
      var response = request.restResponse;
      
      print("Request on");
      print(request.method);
      print(request.httpRequest.uri.path);
      
      if (request.body == null || !request.body.containsKey('bookName')) {
        response.statusCode = 403;
        response['data'] = {'error':'Wrong request!','solution':'Please send me a bookName'};
        response.send();
        return;
      }
      
      print(JSON.encode(request.body));
      
      getBookDatas(request.body['bookName'])
      .then((datas){
        response.statusCode = 200;
        response['datas'] = {'book':datas};
        response.send();
      });
    });
  
  r.post("/hello")
    .listen((ResourceEvent e){
      var request = e.request;
      print("Request on");
      print(request.method);
      print(request.httpRequest.uri.path);
      
      var response = request.restResponse;
      response['data'] = request.body;
      response
        ..statusCode = 200
        ..contentTypeApplicationJson()
        ..send();
    });
  
  r.serve(InternetAddress.LOOPBACK_IP_V4, 4444);
}

Future<Map<String,dynamic>> getBookDatas(String name) {
    Completer<Map<String,dynamic>> c = new Completer<Map<String,dynamic>>();
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
```

Goals
-----

I wanna a create a module based restful framework.
