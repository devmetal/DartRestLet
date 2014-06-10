part of restlet;

abstract class IComponent {
  void init();
  void serve(HttpServer server);
  void stop();
}