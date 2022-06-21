import 'package:flutter/material.dart';
import 'package:lifting_app/color_constants.dart';

class ToolbarWithButtons {
  static AppBar toolbar(List<Widget> _buttons) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 48,
      titleSpacing: 0,
      elevation: 0,
      backgroundColor: ColorConstants.color1,
      flexibleSpace: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _buttons
                      .map((c) => Container(
                            padding: EdgeInsets.only(right: 10),
                            child: c,
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static OutlinedButton button(
      Function _onPressed, String text, IconData icon) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        side: BorderSide(width: 1.0, color: ColorConstants.text1Dark),
      ),
      onPressed: _onPressed,
      label: Text(text, style: TextStyle(color: ColorConstants.color3)),
      icon: Icon(
        icon,
        color: ColorConstants.color3,
      ),
    );
  }
}
