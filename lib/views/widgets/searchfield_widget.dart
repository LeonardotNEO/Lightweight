import 'package:flutter/material.dart';
import 'package:lifting_app/color_constants.dart';

class SearchfieldWidget extends StatefulWidget {
  Function _onChanged;
  String _hintText;
  bool _showOptions = false;
  List<String> _options = [];

  SearchfieldWidget(this._onChanged, this._hintText, this._options) {
    if (_options.isNotEmpty) _showOptions = true;
  }

  @override
  SearchfieldWidgetState createState() => SearchfieldWidgetState();
}

class SearchfieldWidgetState extends State<SearchfieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: widget._showOptions
                    ? BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))
                    : BorderRadius.circular(15),
                color: ColorConstants.text2,
                border: Border.all(width: 0, color: ColorConstants.text1Dark)),
            padding: EdgeInsets.only(left: 10, right: 0, bottom: 0),
            width: double.infinity,
            height: 40,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: widget._onChanged,
                    style:
                        TextStyle(fontSize: 16, color: ColorConstants.color3),
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: ColorConstants.text3),
                        hintText: widget._hintText,
                        icon: Icon(
                          Icons.search,
                          color: ColorConstants.color3,
                        ),
                        border: InputBorder.none),
                  ),
                ),
                widget._options.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            widget._showOptions
                                ? widget._showOptions = false
                                : widget._showOptions = true;
                          });
                        },
                        icon: Icon(
                          Icons.menu,
                          color: ColorConstants.color3,
                        ))
                    : SizedBox.shrink()
              ],
            ),
          ),
          widget._showOptions ? _options(widget._options) : SizedBox.shrink()
        ],
      ),
    );
  }

  Widget _options(List options) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
        color: ColorConstants.text2,
        border: Border.all(width: 0, color: ColorConstants.text1Dark),
      ),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Options:",
              style: TextStyle(fontSize: 12, color: ColorConstants.text3),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Wrap(
                alignment: WrapAlignment.start,
                children: [
                  ..._optionButtons(options),
                ],
              ),
            ),
            Text(
              "Sort by: !Add date, bodypart, name",
              style: TextStyle(fontSize: 12, color: ColorConstants.text3),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _optionButtons(List options) {
    List<Widget> widgets = [];

    for (String option in options) {
      Function _onPressed = null;

      widgets.add(_categoryButton(option, _onPressed));
    }

    return widgets;
  }

  Widget _categoryButton(String option, Function _onPressed) {
    return Container(
      padding: EdgeInsets.only(left: 2, right: 2, top: 2, bottom: 2),
      height: 35,
      width: 92,
      child: DecoratedBox(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30))),
        child: OutlinedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              )),
              side: MaterialStateProperty.all(
                  BorderSide(color: ColorConstants.text1Dark, width: 1))),
          onPressed: _onPressed,
          child: Text(
            option,
            style: TextStyle(fontSize: 12, color: ColorConstants.color3),
          ),
        ),
      ),
    );
  }
}
