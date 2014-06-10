import 'package:rest_let/restlet.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

void main() {
  
  RestServer r = new RestServer('/api');
  
  r.get("/hello/:name/:male")
    .listen((ResourceEvent e){
      var request = e.request;
      print("Request on");
      print(request.method);
      print(request.uri.path);
      
      var route = e.route;
      var name = route.params["name"].getValue();
      var male = route.params["male"].getValue();
      
      request.response
        ..statusCode = 200
        ..headers
          .add('Content-Type', 'text/plain')
        ..write("Hello to ${(male == "1"?"Mr.":"Ms.")} ${name}")
        ..close();
    });
  
  r.post("/book")
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
          ..writeToResponse("<h1>Wrong request</h1>")
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
  
  r.get("/hello")
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
  
  RestLet app = new RestLet();
  app.addComponent(r);
  app.serve(InternetAddress.LOOPBACK_IP_V4, 4444);
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


