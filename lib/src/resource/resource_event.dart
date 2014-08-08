part of restlet.resource;

class ResourceEvent {
  RestRequest request;
  Route route;
  ResourceEvent(this.request,this.route);
}