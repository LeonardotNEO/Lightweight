import 'package:flutter/material.dart';
import 'package:lifting_app/color_constants.dart';
import 'package:lifting_app/views/widgets/toolbar_with_buttons.dart';
import 'package:lifting_app/Models/StoreItem.dart';

class StoreView extends StatefulWidget {
  @override
  _StoreViewState createState() => _StoreViewState();
}

class _StoreViewState extends State<StoreView> {
  int _pageToShow = 1;
  List<StoreItem> _cart = [];
  String _header = "Excersise";

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: ToolbarWithButtons.toolbar(
            [
              ToolbarWithButtons.button(() {
                setState(() {
                  _pageToShow = 4;
                  _header = "Your cart";
                });
              }, "Cart: ${_cart.length}", Icons.shopping_cart_outlined),
              ToolbarWithButtons.button(() {
                setState(() {
                  _pageToShow = 1;
                  _header = "Excersise";
                });
              }, "Excersise", Icons.fitness_center),
              ToolbarWithButtons.button(() {
                setState(() {
                  _pageToShow = 2;
                  _header = "Cutting";
                });
              }, "Cutting", Icons.fitness_center),
              ToolbarWithButtons.button(() {
                setState(() {
                  _pageToShow = 3;
                  _header = "Bulking";
                });
              }, "Bulking", Icons.fitness_center),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _header + ":",
                style: TextStyle(
                    color: ColorConstants.text3,
                    fontWeight: FontWeight.normal,
                    fontSize: 18),
              ),
              _pageToShow == 1
                  ? _storeItems([
                      StoreItem("Workout program: Gain muscle", "sdsdfsdf",
                          "Excersise", 23.99),
                      StoreItem("Workout program: Gain muscle", "sdsdfsdf",
                          "Excersise", 23.99),
                      StoreItem("Workout program: Gain muscle", "sdsdfsdf",
                          "Excersise", 23.99),
                      StoreItem("Workout program: Gain muscle", "sdsdfsdf",
                          "Excersise", 23.99)
                    ], false)
                  : SizedBox.shrink(),
              _pageToShow == 2
                  ? _storeItems([
                      StoreItem("Cutting plan", "sdsdfsdf", "Excersise", 23.99),
                      StoreItem("Cutting plan", "sdsdfsdf", "Excersise", 23.99),
                      StoreItem("Cutting plan", "sdsdfsdf", "Excersise", 23.99),
                      StoreItem("Cutting plan", "sdsdfsdf", "Excersise", 23.99)
                    ], false)
                  : SizedBox.shrink(),
              _pageToShow == 3
                  ? _storeItems([
                      StoreItem("Bulking plan", "sdsdfsdf", "Excersise", 23.99),
                      StoreItem("Bulking plan", "sdsdfsdf", "Excersise", 23.99),
                      StoreItem("Bulking plan", "sdsdfsdf", "Excersise", 23.99),
                      StoreItem("Bulking plan", "sdsdfsdf", "Excersise", 23.99)
                    ], false)
                  : SizedBox.shrink(),
              _pageToShow == 4 ? _storeItems(_cart, true) : SizedBox.shrink(),
              Container(
                height: 130,
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Column _storeItems(List<StoreItem> storeitems, bool inCart) {
    List<Widget> widgets = [];

    storeitems.forEach((item) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 10),
        child: GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorConstants.color3,
            ),
            padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.getName(),
                      style:
                          TextStyle(color: ColorConstants.color1, fontSize: 18),
                    ),
                    Text(item.getPrice().toString() + "\$",
                        style: TextStyle(
                            color: ColorConstants.color1, fontSize: 18)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(item.getDescription(),
                      style: TextStyle(
                          color: ColorConstants.color1, fontSize: 15)),
                ),
                inCart
                    ? _getButton(() {
                        setState(() {
                          _cart.remove(item);
                        });
                      }, "Remove")
                    : _getButton(() {
                        setState(() {
                          _cart.add(item);
                        });
                      }, "Add to cart"),
              ],
            ),
          ),
        ),
      ));
    });

    return Column(
      children: [...widgets],
    );
  }

  Widget _getButton(Function _onPressed, String title) {
    return Center(
      child: OutlinedButton.icon(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(ColorConstants.color1),
              side: MaterialStateProperty.all(
                  BorderSide(color: ColorConstants.color1))),
          onPressed: _onPressed,
          icon: Icon(Icons.add_shopping_cart),
          label: Text(
            title,
          )),
    );
  }
}
