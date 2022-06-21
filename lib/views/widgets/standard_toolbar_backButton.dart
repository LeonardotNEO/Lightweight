import 'package:flutter/material.dart';
import 'package:lifting_app/color_constants.dart';
import 'package:lifting_app/views/widgets/back_button_as_logo.dart';

class StandardToolbarBackButton extends StatelessWidget {
  String _title;
  static const List<Widget> actionsButtons = [];
  static const Widget bottom = SizedBox.shrink();

  StandardToolbarBackButton(this._title, {actionsButtons, bottom});
  @override
  AppBar build(BuildContext context) {
    return AppBar(
        elevation: 0,
        title: Text(
          _title,
          style: TextStyle(color: ColorConstants.text3),
        ),
        leading: BackButtonAsLogo(() => Navigator.pop(context)),
        backgroundColor: ColorConstants.text1Dark,
        actions: [...actionsButtons],
        bottom: bottom);
  }
}
