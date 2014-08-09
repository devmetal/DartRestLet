library restlet.resource;

import 'route.dart';
import 'rest.dart';
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
  
  void dispatch(HttpRequest req, Route route, String routeString) {
    BodyParser parser = new BodyParser.fromStream(req);
    RouteMatch match = route.match(routeString);
    
    parser.body().then((body){
      RestRequest restRequest = new RestRequest(req, body);
      _dsStream.add(new ResourceEvent(restRequest, match, route));
    });
  }
}