import 'package:flutter/material.dart';
import 'package:lifting_app/color_constants.dart';

class PopupMenuWidget extends StatefulWidget {
  Function _onPressed;
  List<PopupMenuItem> _items;
  IconData _icon;

  PopupMenuWidget(this._onPressed, this._items, this._icon);

  @override
  _PopupMenuWidgetState createState() => _PopupMenuWidgetState();
}

class _PopupMenuWidgetState extends State<PopupMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 35,
      child: PopupMenuButton(
          onSelected: widget._onPressed,
          itemBuilder: (context) => widget._items,
          icon: Icon(
            widget._icon,
            color: ColorConstants.color1,
          ),
          padding: EdgeInsets.all(0)),
    );
  }
}
