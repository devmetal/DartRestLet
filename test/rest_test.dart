import 'dart:async';
import 'dart:convert';
import 'package:unittest/unittest.dart';
import 'package:rest_let/rest.dart';

Stream<List<int>> generateByteStreamFromString(String str) {
  List<int> bytes = UTF8.encode(str);
  return new Stream.fromIterable([bytes]);
}

void main() {
  
  RestRequest request;
  
  String streamString = '''
{"book":{
"_id":12,
"name":"Programming in C",
"price":"5000HUF"
}}
''';
  
  group('RestRequestTests',(){
    setUp(() => request = new RestRequest.fromStream(generateByteStreamFromString(streamString)));
    
    test('Test Body',(){
      Future<Map<String,dynamic>> body = request.body();
      expect(body,completion(equals(JSON.decode(streamString))));
    });
  });
  
}