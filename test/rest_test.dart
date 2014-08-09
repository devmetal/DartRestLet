import 'dart:async';
import 'dart:convert';
import 'package:unittest/unittest.dart';
import 'package:rest_let/rest.dart';

Stream<List<int>> generateByteStreamFromString(String str) {
  List<int> bytes = UTF8.encode(str);
  return new Stream.fromIterable([bytes]);
}

void main() {
  
  BodyParser parser;
  
  String streamString = '''
{"book":{
"_id":12,
"name":"Programming in C",
"price":"5000HUF"
}}
''';
  
  group('BodyParserTests',(){
    setUp(() => parser = new BodyParser.fromStream(generateByteStreamFromString(streamString)));
    
    test('Test Body',(){
      Future<Map<String,dynamic>> body = parser.body();
      expect(body,completion(equals(JSON.decode(streamString))));
    });
    
    test('Empty body',(){
      BodyParser empty = new BodyParser.fromStream(generateByteStreamFromString(""));
      Future<Map<String,dynamic>> body = empty.body();
      expect(body,completion(isNull)); 
    });
  });
  
}