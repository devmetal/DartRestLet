part of restlet;

class RestRequest implements HttpRequest {
  
  dynamic body = null;
  
  Future _bodyParsed;
  
  HttpRequest request;
  
  RestRequest(this.request) {
    if (request.contentLength != -1) {
      _bodyParsed = Future.wait([_parseBody()]);
    } else {
      _bodyParsed = new Future.value();
    }
  }
  
  Future _parseBody() {
    Completer c = new Completer();
    UTF8.decodeStream(this.request)
      .then((data){
        body = JSON.decode(data);
        c.complete();
      });
    return c.future;
  }
  
  Future bodyParsed() {
    return _bodyParsed;
  }
  
  void addToResponseHeader(String key, Object value) {
    this.response.headers.add(key, value);
  }
  
  void setResponseStatus(int status) {
    this.response.statusCode = status;
  }
  
  void addToResponse(String key, Object value) {
    this.response.write(JSON.encode({key:value}));
  }
  
  void addAllToResponse(Map<String,dynamic> datas) {
    this.response.write(JSON.encode(datas));
  }
  
  void writeToResponse(Object value) {
    this.response.write(value);
  }
  
  Future sendResponse() {
    return this.response.close();
  }
  
  @override
  Future<bool> any(bool test(List<int> element)) {
    return request.any(test);
  }

  @override
  Stream<List<int>> asBroadcastStream({void onListen(StreamSubscription<List<int>> subscription), void onCancel(StreamSubscription<List<int>> subscription)}) {
    return request.asBroadcastStream(onListen:onListen, onCancel:onCancel);
  }

  @override
  Stream asyncExpand(Stream convert(List<int> event)) {
    return request.asyncExpand(convert);
  }

  @override
  Stream asyncMap(convert(List<int> event)) {
    return request.asyncExpand(convert);
  }

  @override
  X509Certificate get certificate => request.certificate;

  @override
  HttpConnectionInfo get connectionInfo => request.connectionInfo;

  @override
  Future<bool> contains(Object needle) {
    return request.contains(needle);
  }

  @override
  int get contentLength => request.contentLength;

  @override
  List<Cookie> get cookies => request.cookies;

  @override
  Stream<List<int>> distinct([bool equals(List<int> previous, List<int> next)]) {
    return request.distinct(equals);
  }

  @override
  Future drain([futureValue]) {
    return request.drain(futureValue);
  }

  @override
  Future<List<int>> elementAt(int index) {
    return request.elementAt(index);
  }

  @override
  Future<bool> every(bool test(List<int> element)) {
    return request.every(test);
  }

  @override
  Stream expand(Iterable convert(List<int> value)) {
    return request.expand(convert);
  }

  @override
  Future<List<int>> get first => request.first;

  @override
  Future firstWhere(bool test(List<int> element), {Object defaultValue()}) {
    return request.firstWhere(test,defaultValue: defaultValue);
  }

  @override
  Future fold(initialValue, combine(previous, List<int> element)) {
    return request.fold(initialValue, combine);
  }

  @override
  Future forEach(void action(List<int> element)) {
    return request.forEach(action);
  }

  @override
  Stream<List<int>> handleError(Function onError, {bool test(error)}) {
    return handleError(onError,test:test);
  }

  @override
  HttpHeaders get headers => request.headers;

  @override
  bool get isBroadcast => request.isBroadcast;

  @override
  Future<bool> get isEmpty => request.isEmpty;

  @override
  Future<String> join([String separator = ""]) {
    return request.join(separator);
  }

  @override
  Future<List<int>> get last => request.last;

  @override
  Future lastWhere(bool test(List<int> element), {Object defaultValue()}) {
    return request.lastWhere(test,defaultValue:defaultValue);
  }

  @override
  Future<int> get length => request.length;

  @override
  StreamSubscription<List<int>> listen(void onData(List<int> event), {Function onError, void onDone(), bool cancelOnError}) {
    return request.listen(onData,onError:onError,onDone:onDone,cancelOnError:cancelOnError);
  }

  @override
  Stream map(convert(List<int> event)) {
    return request.map(convert);
  }

  @override
  String get method => request.method;

  @override
  bool get persistentConnection => request.persistentConnection;

  @override
  Future pipe(StreamConsumer<List<int>> streamConsumer) {
    return request.pipe(streamConsumer);
  }

  @override
  String get protocolVersion => request.protocolVersion;

  @override
  Future<List<int>> reduce(List<int> combine(List<int> previous, List<int> element)) {
    return request.reduce(combine);
  }

  @override
  Uri get requestedUri => request.requestedUri;

  @override
  HttpResponse get response => request.response;

  @override
  HttpSession get session => request.session;

  @override
  Future<List<int>> get single => request.single;

  @override
  Future<List<int>> singleWhere(bool test(List<int> element)) {
    return request.singleWhere(test);
  }

  @override
  Stream<List<int>> skip(int count) {
    return request.skip(count);
  }

  @override
  Stream<List<int>> skipWhile(bool test(List<int> element)) {
    return request.skipWhile(test);
  }

  @override
  Stream<List<int>> take(int count) {
    return request.take(count);
  }

  @override
  Stream<List<int>> takeWhile(bool test(List<int> element)) {
    return request.takeWhile(test);
  }

  @override
  Stream timeout(Duration timeLimit, {void onTimeout(EventSink sink)}) {
    return request.timeout(timeLimit,onTimeout:onTimeout);
  }

  @override
  Future<List<List<int>>> toList() {
    return request.toList();
  }

  @override
  Future<Set<List<int>>> toSet() {
    return request.toSet();
  }

  @override
  Stream transform(StreamTransformer<List<int>, dynamic> streamTransformer) {
    return request.transform(streamTransformer);
  }

  @override
  Uri get uri => request.uri;

  @override
  Stream<List<int>> where(bool test(List<int> event)) {
    return request.where(test);
  }
}