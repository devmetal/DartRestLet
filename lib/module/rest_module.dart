part of restlet;

abstract class IRestModule {
  Stream<ResourceEvent> get(String route);
  Stream<ResourceEvent> post(String route);
  Stream<ResourceEvent> put(String route);
  Stream<ResourceEvent> delete(String route);
  Stream<ResourceEvent> addResource(String route);
  
  String baseRoute;
  
  IRestModule(this.baseRoute);
}

abstract class IRestModuleContainer implements IRestModule {
  
}

abstract class IRestModuleFactory {
  IRestModule createModule();
}