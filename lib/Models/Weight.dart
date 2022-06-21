class Weight {
  double _load;
  String _type;
  DateTime time;

  Weight(this._load, this._type, {this.time});

  Weight.fromJson(Map<String, dynamic> json) {
    _load = json["load"];
    _type = json["type"];
    time = json["time"] != null
        ? time = DateTime.parse(json["time"])
        : time = null;
  }

  Map<String, dynamic> toJson() {
    return {
      "load": _load,
      "type": _type,
      "time": time != null ? time.toIso8601String() : null
    };
  }

  double getLoad() {
    return _load;
  }

  String getType() {
    return _type;
  }

  void setLoad(double load) {
    _load = load;
  }

  void setType(String type) {
    _type = type;
  }
}
