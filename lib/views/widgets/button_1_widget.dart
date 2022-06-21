import 'package:flutter/material.dart';
import 'package:lifting_app/color_constants.dart';

class Button1 extends StatelessWidget {
  String _header;
  Function _onPressed;

  Button1(this._header, this._onPressed);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton.icon(
          icon: Icon(
            Icons.add,
            size: 20,
            color: ColorConstants.color3,
          ),
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              )),
              backgroundColor:
                  MaterialStateProperty.all(ColorConstants.color1)),
          onPressed: _onPressed,
          label: Text(
            _header,
            style: TextStyle(color: ColorConstants.color3),
          )),
    );
  }
}
