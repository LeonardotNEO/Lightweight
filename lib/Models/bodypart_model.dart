class Bodypart {
  String _name;

  Bodypart(this._name);

  Bodypart.fromJson(Map<String, dynamic> json) {
    _name = json["name"];
  }

  Map<String, dynamic> toJson() {
    return {
      "name": _name,
    };
  }

  void setName(String name) {
    _name = name;
  }

  String getName() {
    return _name;
  }
}
