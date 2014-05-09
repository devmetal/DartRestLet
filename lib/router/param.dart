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