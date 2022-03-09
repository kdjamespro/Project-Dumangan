class CrossCheckMapping {
  final Map<String, String> _crossCheckMapping = {};

  Map<String, String> get crossCheckMapping => _crossCheckMapping;

  void put(String key, String value) {
    _crossCheckMapping[key] = value;
  }

  bool keyExists(String key) {
    return _crossCheckMapping.containsKey(key);
  }

  bool attributeExists(String value) {
    return _crossCheckMapping.containsValue(value);
  }

  bool requiredAttributeExists() {
    return attributeExists('Full Name') && attributeExists('Email');
  }

  List<String> getKeys() {
    return _crossCheckMapping.keys.toList();
  }

  List getValues() {
    return _crossCheckMapping.values.toList();
  }

  void removeAttribute(String key) {
    _crossCheckMapping.remove(key);
  }

  void removeAll() {
    _crossCheckMapping.clear();
  }
}
