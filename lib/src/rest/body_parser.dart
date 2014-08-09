part of restlet.rest;

class BodyParser {
  
  Future _bodyParsed;
  
  Map<String,dynamic> _body;
  
  BodyParser.fromStream(Stream<List<int>> stream) {
    _bodyParsed =  Future.wait([_parseBody(stream)]);
  }
  
  Future _parseBody(Stream<List<int>> stream) {
    Completer c = new Completer();
    
    UTF8.decodeStream(stream)
      .then((data){
        try {
          _body = JSON.decode(data);
          c.complete(_body);
        } catch(ex) {
          c.complete(null);
        }
    });
    
    return c.future;
  }
  
  Future<Map<String,dynamic>> body() {
    return _body == null
            ? _bodyParsed.then((_) => _body)
            : new Future.value(_body);
  }
  
}