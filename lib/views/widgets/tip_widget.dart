import 'package:flutter/material.dart';
import 'package:lifting_app/color_constants.dart';

class TipWidget extends StatelessWidget {
  String _text;

  TipWidget(this._text);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: ColorConstants.text3,
            size: 15,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(this._text,
                  style: TextStyle(fontSize: 14, color: ColorConstants.text3)),
            ),
          ),
        ],
      ),
    );
  }
}
