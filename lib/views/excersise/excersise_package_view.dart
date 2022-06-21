import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lifting_app/Models/ExcersisePackage.dart';
import 'package:lifting_app/Models/Weight.dart';
import 'package:lifting_app/Models/excersise_model.dart';
import 'package:lifting_app/color_constants.dart';
import 'package:lifting_app/main.dart';
import 'package:lifting_app/views/excersise/excersises_view.dart';
import 'package:lifting_app/views/widgets/back_button_as_logo.dart';
import 'package:lifting_app/Models/Set.dart';
import 'package:lifting_app/views/widgets/tip_widget.dart';

class ExcersisePackageView extends StatefulWidget {
  ExcersisePackage _package;
  TextEditingController _title = TextEditingController();
  bool _edit = false;

  ExcersisePackageView.create() : _package = ExcersisePackage("");
  ExcersisePackageView.edit(this._package) : _edit = true {
    _title.text = _package.getPackageName();
  }

  @override
  _ExcersisePackageViewState createState() => _ExcersisePackageViewState();
}

class _ExcersisePackageViewState extends State<ExcersisePackageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _textField(),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TipWidget(
                    "Swipe right or left on excersise or set to remove them."),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Excersises",
                  style: TextStyle(fontSize: 20, color: ColorConstants.text3),
                ),
              ),
              ..._excersisesList(widget._package.getExcersises()),
              Container(
                alignment: Alignment.center,
                child: TextButton.icon(
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(ColorConstants.color3)),
                    onPressed: () async {
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ExcersisesPage.select()));

                      if (result != null) {
                        if (result is ExcersiseModel) {
                          setState(() {
                            widget._package.addExcersise(
                                ExcersiseModel.fromJson(result.toJson()));
                          });
                        }
                        if (result is ExcersisePackage) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Excersise package cant be added to excersise package")));
                        }
                      }
                    },
                    icon: Icon(Icons.add),
                    label: Text(
                      "Excersise",
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      actions: [
        Container(
          child: TextButton.icon(
            style: ButtonStyle(
                foregroundColor:
                    MaterialStateProperty.all(ColorConstants.color3)),
            onPressed: () {
              if (widget._edit) {
                widget._package.setPackageName(widget._title.text);
              } else {
                widget._package.setPackageName(widget._title.text);
                MainPage.getCurrentUser().addExcersisePackage(widget._package);
              }

              Navigator.pop(context);
            },
            icon: Icon(Icons.check),
            label: Text("OK"),
          ),
        )
      ],
      leading: BackButtonAsLogo(() => Navigator.pop(context)),
      backgroundColor: ColorConstants.color1,
    );
  }

  Widget _textField() {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
        decoration: BoxDecoration(
            color: ColorConstants.color3,
            borderRadius: BorderRadius.circular(10)),
        width: double.infinity,
        child: TextField(
          controller: widget._title,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Package name...",
              hintStyle: TextStyle(color: ColorConstants.text2)),
          style: TextStyle(fontSize: 20, color: ColorConstants.text1Dark),
        ));
  }

  List<Widget> _excersisesList(List<ExcersiseModel> excersises) {
    List<Widget> widgets = [];

    excersises.forEach((element) {
      widgets.add(Dismissible(
        key:
            Key(element.hashCode.toString() + Random().nextDouble().toString()),
        onDismissed: (direction) {
          setState(() {
            widget._package.removeExcersise(element);
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorConstants.color3,
              ),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          element.getName(),
                          style: TextStyle(
                              color: ColorConstants.text1Dark, fontSize: 16),
                        ),
                        Text(element.getBodypart().getName(),
                            style: TextStyle(
                                color: ColorConstants.text1Dark, fontSize: 16)),
                      ]),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        ...element
                            .getSets()
                            .map((e) => Dismissible(
                                  onDismissed: (direction) =>
                                      element.removeSet(e),
                                  key: Key(e.hashCode.toString() +
                                      Random.secure().nextDouble().toString()),
                                  direction: DismissDirection.horizontal,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Set ",
                                            style: TextStyle(
                                                color:
                                                    ColorConstants.text1Dark)),
                                        Text(
                                          e.getWeight().getLoad().toString() +
                                              " " +
                                              e.getWeight().getType() +
                                              " x " +
                                              e.getRepetitions().toString(),
                                          style: TextStyle(
                                              color: ColorConstants.text1Dark),
                                        )
                                      ],
                                    ),
                                  ),
                                ))
                            .toList(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    width: 80,
                    child: TextButton.icon(
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(
                                ColorConstants.text1Dark)),
                        onPressed: () {
                          setState(() {
                            element.addSet(Set(
                                0,
                                Weight(0, element.getMeasurementType()),
                                false));
                          });
                        },
                        icon: Icon(Icons.add),
                        label: Text("Set")),
                  )
                ],
              )),
        ),
      ));
    });

    return widgets;
  }
}
