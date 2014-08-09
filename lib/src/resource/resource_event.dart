part of restlet.resource;

class ResourceEvent {
  RestRequest request;
  Route route;
  RouteMatch match;
  ResourceEvent(this.request,this.match,this.route);
}