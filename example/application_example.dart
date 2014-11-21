import 'package:rest_let/application.dart';

@module('/welcome')
class WelcomeModule {
  @action('/:name','GET')
  echo(name) => print("Request from ${name}");
}

main() {
  Application app = new Application();
  app.addModule(new WelcomeModule());
  app.start();
}