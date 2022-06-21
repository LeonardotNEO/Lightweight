import 'package:flutter/material.dart';
import 'package:lifting_app/Models/bodypart_model.dart';
import 'package:lifting_app/Models/ExcersisePackage.dart';
import 'package:lifting_app/Models/excersise_model.dart';
import 'package:lifting_app/Models/Workout.dart';
import 'package:lifting_app/main.dart';
import 'package:lifting_app/views/excersise/excersise_package_view.dart';
import 'package:lifting_app/views/excersise/excersise_view.dart';
import 'package:lifting_app/color_constants.dart';
import 'package:lifting_app/views/widgets/back_button_as_logo.dart';
import 'package:lifting_app/views/widgets/popup_menu_widget.dart';
import 'package:lifting_app/views/widgets/tip_widget.dart';
import '../widgets/card_widget.dart';
import '../widgets/button_1_widget.dart';

class ExcersisesPage extends StatefulWidget {
  bool _select = false;

  ExcersisesPage();
  ExcersisesPage.select() : _select = true;

  @override
  _ExcersisesPageState createState() => _ExcersisesPageState();
}

class _ExcersisesPageState extends State<ExcersisesPage> {
  List<ExcersiseModel> _excersisesToShow =
      MainPage.getCurrentUser().getExcersises();
  List<ExcersisePackage> _packagesToShow =
      MainPage.getCurrentUser().getExcersisesPackages();
  bool _showExcersiseCategories = false;
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return widget._select ? _selectExcersiseBuild() : _excersiesBuild();
  }

  Widget _excersiesBuild() {
    return Column(
      children: [
        _appbar(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: IndexedStack(
            index: _pageIndex,
            children: [_excersises(), _excersisePackages()],
          ),
        ),
      ],
    );
  }

  Widget _selectExcersiseBuild() {
    return Scaffold(
      appBar: AppBar(
        leading: BackButtonAsLogo(() => Navigator.pop(context)),
        backgroundColor: ColorConstants.color1,
        bottom: PreferredSize(
          preferredSize: new Size.fromHeight(35),
          child: _appbar(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: IndexedStack(
                index: _pageIndex,
                children: [_excersises(), _excersisePackages()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appbar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: ColorConstants.color1,
      toolbarHeight: 25,
      elevation: 0,
      flexibleSpace: Row(children: [
        Expanded(
          child: TextButton.icon(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(_pageIndex == 0
                      ? ColorConstants.color3
                      : ColorConstants.text3)),
              label: Text("Excersises"),
              onPressed: () {
                setState(() {
                  _pageIndex = 0;
                });
              },
              icon: Icon(
                Icons.fitness_center,
              )),
        ),
        Container(
          width: 1,
          height: 35,
          color: ColorConstants.color3,
        ),
        Expanded(
          child: TextButton.icon(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(_pageIndex == 1
                      ? ColorConstants.color3
                      : ColorConstants.text3)),
              label: Text("Packages"),
              onPressed: () {
                setState(() {
                  _pageIndex = 1;
                });
              },
              icon: Icon(Icons.storage)),
        ),
      ]),
    );
  }

  Widget _excersises() {
    Function _onChanged = (text) {
      setState(() {
        if (text.isEmpty) {
          _excersisesToShow = MainPage.getCurrentUser().getExcersises();
        } else {
          _excersisesToShow = ExcersiseModel.getExcersisesWithName(
              text, MainPage.getCurrentUser());
        }
      });
    };

    return Column(
      children: [
        Button1("Create excersise", () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_context) => ExcersisePage.newExcersise()));

          setState(() {});
        }),
        _searchBar("Search for excersise...", _onChanged,
            MainPage.getCurrentUser().getBodyparts()),
        ..._getExcersisesAsWidgets(_excersisesToShow),
        Container(height: 130)
      ],
    );
  }

  Widget _excersisePackages() {
    Function _onChanged = (text) {
      setState(() {
        if (text.isEmpty) {
          _packagesToShow = MainPage.getCurrentUser().getExcersisesPackages();
        } else {
          _packagesToShow = ExcersisePackage.getExcersisePackageWithName(
              text, MainPage.getCurrentUser());
        }
      });
    };

    return Column(
      children: [
        TipWidget(
            "If you are unsure which excersise to do for a bodypart in a workout, create a excersise package so you can faster choose an excersise while in a workout!"),
        Button1("Create package", () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_context) => ExcersisePackageView.create()));

          setState(() {});
        }),
        _searchBar("Search for excersise package...", _onChanged, null),
        ..._getExcersisePackagesAsWidgets(_packagesToShow),
        Container(height: 130)
      ],
    );
  }

  void _deleteExcersiseAlert(ExcersiseModel excersise) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete excersise'),
        content: const Text(
            'Are you sure you want to delete this excersise permanently?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteExcersise(excersise);
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _deleteExcersise(ExcersiseModel excersiseModel) {
    setState(() {
      MainPage.getCurrentUser().deleteExcersise(excersiseModel);
    });
  }

  void _deleteExcersisePackageAlert(ExcersisePackage package) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete excersise'),
        content: const Text(
            'Are you sure you want to delete this excersise package permanently?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deletePackage(package);
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _deletePackage(ExcersisePackage package) {
    setState(() {
      MainPage.getCurrentUser().removeExcersisePackage(package);
    });
  }

  List<Widget> _getExcersisesAsWidgets(List list) {
    List<Widget> excersiseWidgets = [];

    for (ExcersiseModel excersise in list) {
      Widget _child = _excersiseCardContent(excersise);

      Function _onPressedPopup = (value) => {
            if (value == 1)
              {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ExcersisePage.editExcersise(excersise)))
              }
            else if (value == 2)
              {_deleteExcersiseAlert(excersise)}
          };

      List<PopupMenuItem> _items = [
        PopupMenuItem(
          child: Text("Edit"),
          value: 1,
        ),
        PopupMenuItem(
          child: Text("Delete"),
          value: 2,
        ),
      ];

      excersiseWidgets.add(
        CardWidget.withHeader(
          _child,
          widget._select
              ? () => Navigator.pop(context, excersise)
              : () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ExcersisePage.editExcersise(excersise))),
          excersise.getName(),
          PopupMenuWidget(_onPressedPopup, _items, Icons.menu),
        ),
      );
    }

    return excersiseWidgets;
  }

  List<Widget> _getExcersisePackagesAsWidgets(List list) {
    List<Widget> excersiseWidgets = [];

    for (ExcersisePackage excersisePackage in list) {
      Widget _child = _excersisePackageCardContent(excersisePackage);

      Function _onPressedPopup = (value) async {
        if (value == 1) {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ExcersisePackageView.edit(excersisePackage)));

          setState(() {});
        } else if (value == 2) {
          _deleteExcersisePackageAlert(excersisePackage);
        }
      };

      List<PopupMenuItem> _items = [
        PopupMenuItem(
          child: Text("Edit"),
          value: 1,
        ),
        PopupMenuItem(
          child: Text("Delete"),
          value: 2,
        ),
      ];

      excersiseWidgets.add(
        CardWidget.withHeader(
          _child,
          widget._select
              ? () => Navigator.pop(
                  context, ExcersisePackage.fromJson(excersisePackage.toJson()))
              : () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ExcersisePackageView.edit(excersisePackage))),
          excersisePackage.getPackageName(),
          PopupMenuWidget(_onPressedPopup, _items, Icons.menu),
          spaceNextElement: 10,
          backgroundColor: ColorConstants.color3,
        ),
      );
    }

    return excersiseWidgets;
  }

  Widget _excersiseCardContent(ExcersiseModel excersise) {
    return Text(
      "${excersise.getBodypart().getName()}",
      style: TextStyle(
          fontSize: 14,
          color: ColorConstants.color1,
          fontWeight: FontWeight.normal),
    );
  }

  Widget _excersisePackageCardContent(ExcersisePackage excersisePackage) {
    List<Widget> widgets = [];
    excersisePackage.getExcersises().forEach((excersise) {
      widgets.add(Container(
        padding: EdgeInsets.only(top: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              excersise.getName(),
              style: TextStyle(color: ColorConstants.text1Dark),
            ),
            Text(excersise.getBodypart().getName(),
                style: TextStyle(color: ColorConstants.text1Dark))
          ],
        ),
      ));
    });

    return Column(
      children: [
        ...widgets,
      ],
    );
  }

  Widget _searchBar(String hintText, Function _onChanged, List categories) {
    return Padding(
      padding: const EdgeInsets.only(),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: _showExcersiseCategories
                    ? BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))
                    : BorderRadius.circular(15),
                color: ColorConstants.color1,
                border: Border.all(width: 1, color: ColorConstants.text1Dark)),
            padding: EdgeInsets.only(left: 10, right: 0, bottom: 0),
            width: double.infinity,
            height: 40,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: _onChanged,
                    style:
                        TextStyle(fontSize: 16, color: ColorConstants.color3),
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: ColorConstants.text3),
                        hintText: hintText,
                        icon: Icon(
                          Icons.search,
                          color: ColorConstants.color3,
                        ),
                        border: InputBorder.none),
                  ),
                ),
                categories != null
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _showExcersiseCategories
                                ? _showExcersiseCategories = false
                                : _showExcersiseCategories = true;
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
          categories != null
              ? (_showExcersiseCategories
                  ? _categories(categories)
                  : SizedBox.shrink())
              : SizedBox.shrink()
        ],
      ),
    );
  }

  Widget _categories(List categories) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
        color: ColorConstants.color1,
        border: Border.all(width: 1, color: ColorConstants.text1Dark),
      ),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Categories:",
              style: TextStyle(fontSize: 12, color: ColorConstants.text1Dark),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Wrap(
                alignment: WrapAlignment.start,
                children: [
                  ..._categoryButtons(categories),
                ],
              ),
            ),
            Text(
              "Sort by: !Add date, bodypart, name",
              style: TextStyle(fontSize: 12, color: ColorConstants.text1Dark),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _categoryButtons(List categories) {
    List<Widget> widgets = [
      _categoryButton(Bodypart("All"), () {
        setState(() {
          _excersisesToShow = MainPage.getCurrentUser().getExcersises();
        });
      })
    ];

    for (Bodypart bodypart in categories) {
      Function _onPressed = () {
        setState(() {
          _excersisesToShow = ExcersiseModel.getExcersisesWithBodypart(
              bodypart, MainPage.getCurrentUser());
        });
      };

      widgets.add(_categoryButton(bodypart, _onPressed));
    }

    return widgets;
  }

  Widget _categoryButton(Bodypart bodypart, Function _onPressed) {
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
            bodypart.getName(),
            style: TextStyle(fontSize: 12, color: ColorConstants.color3),
          ),
        ),
      ),
    );
  }
}
