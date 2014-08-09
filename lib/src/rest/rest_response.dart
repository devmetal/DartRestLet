part of restlet.rest;

class RestResponse extends MapBase {
  
  HttpResponse _httpResponse;
  
  HttpHeaders _responseHeaders;
  
  Map<String,dynamic> _innerMap;
  
  RestResponse(this._httpResponse) {
    _innerMap = <String,dynamic>{};
    _responseHeaders = _httpResponse.headers;
  }
  
  Future send() {
    _contentTypeApplicationJson();
    _writeContent();
    return _send();
  }
  
  void _contentTypeApplicationJson() {
    _responseHeaders.contentType = new ContentType('application', 'json',charset: 'utf-8');
  }
  
  void _writeContent() {
    List<int> bytes = UTF8.encode(JSON.encode(_innerMap));
    _httpResponse.add(bytes);
  }
  
  Future _send() {
    return _httpResponse.close();
  }
  
  HttpHeaders get headers => _responseHeaders;
  
  HttpResponse get httpResponse => _httpResponse;
  
  set statusCode(int code) => _httpResponse.statusCode = code;

  @override
  operator [](Object key) => _innerMap[key];

  @override
  operator []=(key, value) => _innerMap[key] = value;

  @override
  void clear() => _innerMap.clear();

  @override
  Iterable get keys => _innerMap.keys;
  
  @override
  remove(Object key) => _innerMap.remove(key);
}