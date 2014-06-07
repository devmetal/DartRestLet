part of restlet;

abstract class IComponent {
  void init();
  void serve();
  void stop();
}