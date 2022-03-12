class AttributeMapping {
  final Map<String, String> _columnToAttribute = {};

  Map<String, String> get columnToAttribute => _columnToAttribute;

  void put(String key, String value) {
    _columnToAttribute[key] = value;
  }

  bool keyExists(String key) {
    return _columnToAttribute.containsKey(key);
  }

  bool attributeExists(String value) {
    return _columnToAttribute.containsValue(value);
  }

  bool requiredAttributeExists() {
    return attributeExists('Full Name') && attributeExists('Email');
  }

  List<String> getKeys() {
    return _columnToAttribute.keys.toList();
  }

  List getValues() {
    return _columnToAttribute.values.toList();
  }

  void removeAttribute(String key) {
    _columnToAttribute.remove(key);
  }

  void removeAll() {
    _columnToAttribute.clear();
  }
}
