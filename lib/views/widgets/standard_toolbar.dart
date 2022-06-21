import 'package:flutter/material.dart';
import 'package:lifting_app/color_constants.dart';
import 'package:lifting_app/main.dart';
import 'package:lifting_app/views/settings_view.dart';
import 'package:lifting_app/views/store_view.dart';

class StandardToolbar extends StatelessWidget {
  Widget _leading;
  Widget _bottom;

  StandardToolbar(this._leading, this._bottom);

  @override
  SliverAppBar build(BuildContext context) {
    return SliverAppBar(
      bottom: _bottom != null ? _bottom : null,
      leading: _leading == null ? null : _leading,
      automaticallyImplyLeading: _leading == null ? false : true,
      backgroundColor: ColorConstants.color1,
      floating: false,
      pinned: true,
      expandedHeight: 100,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsetsDirectional.only(start: 10, bottom: 16),
        //background: Image(
        //    fit: BoxFit.cover,
        //    image: AssetImage(
        //        'assets/images/gym-weights-under-strong-dramatic-260nw-472696720.jpg')),
        title: Text(
          MainPage.getHeaderText(),
          style: TextStyle(color: ColorConstants.color3),
        ),
      ),
      actions: [
        IconButton(
            onPressed: () => MainPage.setCurrentPage(StoreView(), "Store"),
            icon: Icon(
              Icons.local_grocery_store_outlined,
              color: ColorConstants.color3,
            )),
        IconButton(
            onPressed: () => MainPage.setCurrentPage(Settings(), "Settings"),
            icon: Icon(
              Icons.settings,
              color: ColorConstants.color3,
            )),
      ],
    );
  }
}
