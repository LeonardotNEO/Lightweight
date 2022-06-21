import 'package:flutter/material.dart';

class StoreItem {
  String _name;
  static const Image _previewImage = null;
  String _description;
  String _category;
  double _price;
  bool _bought;

  StoreItem(this._name, this._description, this._category, this._price,
      {previewImage: _previewImage});

  String getName() {
    return _name;
  }

  String getDescription() {
    return _description;
  }

  String getCategory() {
    return _category;
  }

  double getPrice() {
    return _price;
  }
}
