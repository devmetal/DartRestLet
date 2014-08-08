library restlet.resource;

import 'route.dart';
import 'src/rest/rest_request.dart';
import 'dart:async';
import 'dart:io';

part './src/resource/resource_event.dart';
part './src/resource/resource_factory.dart';

class Resource {
  Route route;
  String method;
  
  StreamController<ResourceEvent> _dsStream;
  
  Stream<ResourceEvent> getDispatcher() {
    return _dsStream.stream;
  }

  Resource(this.method, String url) {
    route = new Route.fromString(url);
    _dsStream = new StreamController<ResourceEvent>();
  }
  
  void dispatch(HttpRequest req,Route route) {
    RestRequest restReq = new RestRequest(req);
    restReq.bodyParsed().then((_){
      _dsStream.add(new ResourceEvent(restReq,route));
    });
  }
}