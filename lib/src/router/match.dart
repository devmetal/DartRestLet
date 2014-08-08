part of restlet.router;

class RouteMatch {
  
  List<Param<String,dynamic>> _params = <Param<String,dynamic>>[];
  
  RouteMatch.fromRouteMatches(Iterable<Match> matches, Iterable<String> names) {
    Match match = matches.elementAt(0);
    for (int i = 0; i<match.groupCount; i++) {
      var key = names.elementAt(i);
      var val = match.group(i + 1);
      _params.add(new Param<String,dynamic>(key,val));
    }
  }
  
  dynamic getValue(String name) {
    var elem = _params.firstWhere((e) => e.getKey() == name, orElse: () => null);
    if (elem != null) {
      return elem.getValue();
    } else {
      return null;
    }
  }
  
  operator [](String name){
    return getValue(name);
  }
  
}

