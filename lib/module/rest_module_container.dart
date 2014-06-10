part of restlet;

abstract class IRestModuleContainer implements IRestModule {
  void add(IRestModule module);
  bool rem(IRestModule module);
  
  IRestModule getModule(String route);
}