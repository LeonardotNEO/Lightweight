import 'package:flutter/material.dart';
import 'package:lifting_app/color_constants.dart';

class CardWidget extends StatelessWidget {
  Function _onPressed;
  Widget _child;
  Widget _header;
  Widget _popupMenu;
  String _headerText;
  static const double spaceNextElement = 5.0;
  final Color backgroundColor = ColorConstants.color3;
  final Color textColorHeader = ColorConstants.text1Dark;

  CardWidget(this._child, this._onPressed, {backgroundColor, spaceNextElement});
  CardWidget.withHeader(
      this._child, this._onPressed, this._headerText, this._popupMenu,
      {textColor, backgroundColor, spaceNextElement}) {
    _header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _headerText,
          style: TextStyle(
            fontSize: 16,
            color: textColorHeader,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(width: 25, height: 25, child: _popupMenu)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: spaceNextElement),
      child: GestureDetector(
        onTap: _onPressed,
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          decoration: BoxDecoration(
              color: backgroundColor, borderRadius: BorderRadius.circular(10)),
          alignment: Alignment.topLeft,
          child: _header == null
              ? _child
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_header, _child],
                ),
        ),
      ),
    );
  }
}
