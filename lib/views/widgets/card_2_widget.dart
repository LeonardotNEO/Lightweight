import 'package:flutter/material.dart';
import 'package:lifting_app/color_constants.dart';

class Card2 extends StatelessWidget {
  String _cardTitle;
  Function _onPressed;
  IconData _icon;

  Card2(this._cardTitle, this._onPressed, this._icon);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
      child: GestureDetector(
        onTap: _onPressed,
        child: Container(
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
              color: ColorConstants.color3,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(50),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(50))),
          width: double.infinity,
          height: 80,
          padding: EdgeInsets.all(10),
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _cardTitle,
                    style:
                        TextStyle(fontSize: 25, color: ColorConstants.color1),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: ColorConstants.color1,
                    size: 30,
                  )
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(right: 100),
                alignment: Alignment.centerRight,
                child: Icon(
                  _icon,
                  size: 60,
                  color: ColorConstants.text1Dark,
                ))
          ]),
        ),
      ),
    );
  }
}
