part of restlet;

class ResourceEvent {
  HttpRequest request;
  Route route;
  ResourceEvent(this.request,this.route);
}