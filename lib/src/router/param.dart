part of restlet.router;

class Param<K,V> {
  V _value;
  K _name;
  
  Param(this._name,[this._value]);
  
  void setValue(V value){
    _value = value;
  }
  
  V getValue() {
    return _value;
  }
  
  K getKey() {
    return _name;
  }
}