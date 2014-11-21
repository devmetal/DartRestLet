library application;

import 'dart:mirrors';

import 'restlet.dart';
import 'dart:io';

class module {
  final String baseRoute;
  const module(this.baseRoute);
}

class action {
  final String method;
  final String route;
  const action(this.route, this.method);
}

class Action {
  final String method;
  final String route;
  final ClassMirror mirror;
  final Symbol symbol;
  
  Action(this.method,this.route,this.mirror,this.symbol);
}

class ActionResourceFactory extends ResourceFactory {
  final Action _action;
  
  ActionResourceFactory(this._action);
  
  @override
  Resource createResource(String url) {
    return new Resource(_action.method, _action.route);
  }
}

class Annotation<T> {
  final DeclarationMirror mirror;
  const Annotation(this.mirror);
  
  bool hasAnnotation() {
    return mirror.metadata.any(_reflectee);
  }
 
  T getAnnotation() {
    try {
      return mirror.metadata
          .firstWhere(_reflectee)
          .reflectee;
    } catch(err) {
      return null;
    }
  }
  
  bool _reflectee(InstanceMirror inst) => 
        inst.hasReflectee && inst.reflectee.runtimeType == T;
}

class ModuleAnnotation extends Annotation<module> {
  ModuleAnnotation(DeclarationMirror mirror) : super(mirror);
}

class ActionAnnotation extends Annotation<action> {
  ActionAnnotation(DeclarationMirror mirror) : super(mirror);
}

class MetadataParser {
  ClassMirror _mirror;
  ModuleAnnotation _moduleA;
  String _baseRoute;
  
  MetadataParser(Type t) {
    _mirror = reflectClass(t);
    _moduleA = new ModuleAnnotation(_mirror);
    
    _checkMirror();
    _parseModule();
  }
  
  _checkMirror() {
    if (!_moduleA.hasAnnotation()) {
      throw "Missing module annotation";
    }
  }
  
  _parseModule() {
    module m = _moduleA.getAnnotation();
    _baseRoute = m.baseRoute;
  }
  
  List<Action> actions() {
    List<Action> actions = <Action>[];
    _mirror.declarations.forEach((sym,dcm){
      var actionAnn = new ActionAnnotation(dcm);
      if (actionAnn.hasAnnotation()) {
        var _a = actionAnn.getAnnotation();
        Action action = new Action(_a.method,_baseRoute + _a.route,_mirror,sym);
        actions.add(action);
      }
    });
    return actions;
  }
  
  String baseRoute() => _baseRoute; 
}

class Application {
  final RestLet _restLet = new RestLet();
  Application();
  
  void addModule(dynamic module) {
    MetadataParser parser = new MetadataParser(module.runtimeType);
    parser.actions().forEach((Action a) => 
      _restLet.addResource(_createResource(a)).listen(_createListener(module,a))
    );
  }
  
  void start() {
    _restLet.serve(InternetAddress.LOOPBACK_IP_V4, 4444);
  }
  
  Resource _createResource(Action a) => 
      new ActionResourceFactory(a).createResource(a.route);
  
  Function _createListener(dynamic m,Action a) {
    void listener(ResourceEvent evt) {
      List<dynamic> params = evt.match.getValuesAsList();
      RestRequest request = evt.request;
      RestResponse response = request.restResponse;
      
      InstanceMirror instance = reflect(m);
      instance.invoke(a.symbol, params);
    }
    
    return listener;
  }
}