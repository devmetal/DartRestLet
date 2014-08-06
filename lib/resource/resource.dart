part of restlet;

class Resource {
  Route route;
  String method;
  
  StreamController<ResourceEvent> _dsStream;
  
  Stream<ResourceEvent> getDispatcher() {
    return _dsStream.stream;
  }

  Resource(this.method, String url) {
    //route = new Route(url);
    _dsStream = new StreamController<ResourceEvent>();
  }
  
  void dispatch(HttpRequest req,Route route) {
    RestRequest restReq = new RestRequest(req);
    restReq.bodyParsed().then((_){
      _dsStream.add(new ResourceEvent(restReq,route));
    });
  }
}