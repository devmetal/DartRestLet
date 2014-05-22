part of restlet;

class ResourceEvent {
  RestRequest request;
  Route route;
  ResourceEvent(this.request,this.route);
}