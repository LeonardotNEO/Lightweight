import 'package:lifting_app/Models/Weight.dart';

class Set {
  int _repetitions;
  Weight _weight;
  bool _finished;

  Set(this._repetitions, this._weight, this._finished);

  Set.fromJson(Map<String, dynamic> json)
      : _repetitions = json["repetitions"],
        _weight = Weight.fromJson(json["weight"]),
        _finished = json["finished"];

  Map<String, dynamic> toJson() => {
        "repetitions": _repetitions,
        "weight": _weight.toJson(),
        "finished": _finished,
      };

  int getRepetitions() {
    return this._repetitions;
  }

  void setRepetitions(int repetitions) {
    this._repetitions = repetitions;
  }

  Weight getWeight() {
    return this._weight;
  }

  void setWeight(Weight weight) {
    this._weight = weight;
  }

  bool getFinished() {
    return this._finished;
  }

  void setFinished(bool finished) {
    this._finished = finished;
  }
}
