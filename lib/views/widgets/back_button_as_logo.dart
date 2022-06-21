import 'package:flutter/material.dart';
import 'package:lifting_app/color_constants.dart';

class BackButtonAsLogo extends StatelessWidget {
  Function _goBack;
  static const double _size = 30;
  static const IconData _icon = Icons.arrow_back;

  BackButtonAsLogo(this._goBack, {size: _size, icon: _icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: IconButton(
          onPressed: _goBack,
          icon: Icon(
            _icon,
            size: _size,
            color: ColorConstants.color3,
          )),
    );
  }
}
