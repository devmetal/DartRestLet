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
  
  bool containsIndex(int index) {
    return _params.keys.any((key) => key.index == index);
  }
  
  bool containsName(String name) {
    return _params.keys.any((key) => key.name == name);
  }
  
  bool containsKey(ParamMapEntryKey key) {
    return _params.containsKey(key);
  }
  
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
  
  operator [](String name) => 
    getByName(name);
  
  operator [](int index) =>
    getByIndex(index);
  
  operator []=(ParamMapEntryKey key, Param p) => 
    _params[key] = p;
  
  operator []=(String name, Param p) {
    Param _p = getByName(name);
    if (_p != null) {
      _p = p; 
    } else {
      int index = _getMaxIndex() + 1;
      this[new ParamMapEntryKey(index,name)] = p;
    }
  }
  
  operator []=(int index, Param p) {
    Param _p = getByIndex(index);
    if (_p != null) {
      _p = p;
    } else {
      this[new ParamMapEntryKey(index,"")] = p; 
    }
  }
  
  int _getMaxIndex() {
    int max = -1;
    this._params.keys.forEach((e){
      if (e.index > max) {
        max = e.index;
      }
    });
    return max;
  }
}

