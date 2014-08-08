part of restlet.rest;

class RestRequest {
  
  Map<String,String> _parameters;
  
  Future _bodyParsed;
  
  Map<String,dynamic> _body;
  
  HttpRequest _request;
  
  HttpHeaders _headers;
  
  RestResponse _response;
  
  String _method;
  
  String _contentType;
  
  RestRequest.fromStream(Stream<List<int>> byteStream) {
    _bodyParsed = Future.wait([_parseBody(byteStream)]);
  }
  
  RestRequest(this._request) {
    _headers = _request.headers;
    _method = _request.method;
    _contentType = _headers.contentType.mimeType;
    _parameters = _request.requestedUri.queryParameters;
    _response = new RestResponse(_request.response);
    
    if (_contentType != 'application/json') {
      throw "Invalid Content-Type!";
    }
    
    if (['GET','DELETE'].contains(_method)) {
      _bodyParsed = new Future<Map<String,dynamic>>.value(null);
    } else if(_request.contentLength != -1) {
      _bodyParsed = Future.wait([_parseBody(_request)]);
    } else {
      _bodyParsed = new Future<Map<String,dynamic>>.value(null);
    }
  }
  
  Future _parseBody(Stream<List<int>> stream) {
    Completer c = new Completer();
    UTF8.decodeStream(stream)
      .then((data){
        _body = JSON.decode(data);
        c.complete(_body);
      });
    
    return c.future;
  }
  
  Future<Map<String,dynamic>> body() {
    return _body == null
            ? _bodyParsed.then((_) => _body)
            : new Future.value(_body);
  }
  
  operator [](String name) => _parameters[name];
  
  HttpRequest get request => _request;
  
}