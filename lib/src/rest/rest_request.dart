part of restlet.rest;

class RestRequest {
  
  Map<String,List<String>> _headerParameters;
  
  Map<String,String> _parameters;
  
  Map<String,dynamic> _body;
  
  HttpRequest _request;
  
  HttpHeaders _headers;
  
  RestResponse _response;
  
  String _method;
  
  String _contentType;
  
  RestRequest(this._request, this._body) {
    _initHeaders();
    _initParameters();
    _initResponse();
  }
  
  void _initHeaders() {
    _headers = _request.headers;
    _headerParameters = <String,List<String>>{};
    
    _headers.forEach((key,value){
      _headerParameters[key] = value;
    });
    
    _method = _request.method;
    var contentType = _headers.contentType;
    if (contentType != null) {
      _contentType = contentType.mimeType;
    }
  }
  
  void _initParameters() {
    _parameters = _request.requestedUri.queryParameters;
  }
  
  void _initResponse() {
    _response = new RestResponse(_request.response);
  }
  
  String getHeader(String name) {
    StringBuffer _buff = new StringBuffer();
    if (_headerParameters.containsKey(name)) {
      _buff.writeAll(_headerParameters[name],';');
      return _buff.toString();
    } else {
      return null;
    }
  }
  
  String getQueryParam(String name) => _parameters[name];
  
  Map<String,dynamic> get body => _body;
  
  HttpRequest get httpRequest => _request;
  
  HttpHeaders get headers => _headers;
  
  RestResponse get restResponse => _response;
  
  String get method => _method;
  
  String get contentType => _contentType;
  
}