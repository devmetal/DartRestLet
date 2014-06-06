part of restlet;

class Param<T> {
  T _value;
  String _name;
  
  Param(this._name,[this._value]);
  
  void setValue(T value){
    _value = value;
  }
  
  T getValue() {
    return _value;
  }
  
  String getName() {
    return _name;
  }
}

class ParamMapEntryKey {
  int    index;
  String name;
  
  ParamMapEntryKey(this.index, this.name);
  
  operator ==(ParamMapEntryKey other) =>
      this.index == other.index || this.name == other.name;
}

class ParamMap {
  Map<ParamMapEntryKey, Param> _params;
  
  ParamMap() {
    _params = <ParamMapEntryKey,Param>{};
  }
  
  bool containsIndex(int index) {
    return _params.keys.any((key) => key.index == index);
  }
  
  bool containsName(String name) {
    return _params.keys.any((key) => key.name == name);
  }
  
  bool containsKey(ParamMapEntryKey key) {
    return _params.containsKey(key);
  }
  
  bool get isNotEmpty => _params.isNotEmpty;
  bool get isEmpty    => _params.isEmpty;
  
  Iterable<ParamMapEntryKey> get keys => _params.keys;
  
  Param getByIndex(int index) {
    ParamMapEntryKey key;
    Iterable<ParamMapEntryKey> keys;
    if (!containsIndex(index)) {
      return null;
    }
    
    keys = this._params.keys;
    key  = keys.singleWhere((k) => k.index == index);
    return this._params[key];
  }
  
  Param getByName(String name) {
    ParamMapEntryKey key;
    Iterable<ParamMapEntryKey> keys;
    if (!containsName(name)) {
      return null;
    }
    
    keys = this._params.keys;
    key  = keys.singleWhere((k) => k.name == name);
    return this._params[key];
  }
  
  ParamMapEntryKey getKeyByIndex(int index) {
    Iterable<ParamMapEntryKey> keys;
    if (!containsIndex(index)) {
      return null;
    }
    
    keys = this._params.keys;
    return keys.singleWhere((k) => k.index == index);
  }
  
  ParamMapEntryKey getKeyByName(String name) {
    Iterable<ParamMapEntryKey> keys;
    if (!containsName(name)) {
      return null;
    }
    
    keys = this._params.keys;
    return keys.singleWhere((k) => k.name == name);
  }
  
  void putByIndex(int index, Param p) {
    var k = getKeyByIndex(index);
    if (k != null) {
      this._params[k] = p;
    } else {
      this._params[new ParamMapEntryKey(index,"")] = p; 
    }
  }
  
  void putByName(String name, Param p) {
    var k = getKeyByName(name);
    if (k != null) {
      this._params[k] = p; 
    } else {
      int index = _getMaxIndex() + 1;
      this._params[new ParamMapEntryKey(index,name)] = p;
    }
  }
  
  operator [](String name) => 
    getByName(name);
  
  operator []=(String name, Param p) =>
    putByName(name, p);
   
  int _getMaxIndex() {
    int max = -1;
    this._params.keys.forEach((e){
      if (e.index > max) {
        max = e.index;
      }
    });
    return max;
  }
  
  String toString() {
    String tmp = "";
    _params.forEach((k,v){
      tmp += "${k.index}. ${k.name} = ${v.getValue()}\n";
    });
    return tmp;
  }
}

