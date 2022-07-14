import 'package:cricland_admin/constants/dynamic_size.dart';
import 'package:cricland_admin/constants/routes.dart';
import 'package:cricland_admin/constants/static_colors.dart';
import 'package:cricland_admin/repository/home/controller/home_controller.dart';
import 'package:flutter/material.dart';

@immutable
class AdminScaffold extends StatefulWidget {
  final List<ScaffoldMenuItem> menuItem;
  final String title;
  late Function(ScaffoldMenuItem) onMenuTap;
  final Widget body;

  AdminScaffold(
      {Key? key,
      required this.menuItem,
      required this.title,
      required this.onMenuTap,
      required this.body})
      : super(key: key);

  @override
  State<AdminScaffold> createState() => _AdminScaffoldState();
}

class _AdminScaffoldState extends State<AdminScaffold> {
  late String selectedRoute;

  @override
  void initState() {
    super.initState();
    selectedRoute = widget.menuItem.first.route;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    HomeController.instance.changeCurrentScreen(Routes.home);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: StaticColor.sideBarColor,
                        border: Border(
                            bottom: BorderSide(
                                color: StaticColor.hintColor, width: 0.5))),
                    padding: EdgeInsets.symmetric(vertical: dynamicSize(.022)),
                    child: Text(
                      widget.title,
                      style: TextStyle(
                          color: StaticColor.primaryColor,
                          fontSize: dynamicSize(.023),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: Drawer(
                    elevation: 0.0,
                    backgroundColor: StaticColor.sideBarColor,
                    child: ListView.builder(
                      itemCount: widget.menuItem.length,
                      itemBuilder: (context, index) => ListTile(
                        tileColor: selectedRoute == widget.menuItem[index].route
                            ? StaticColor.primaryColor
                            : Colors.transparent,
                        textColor: selectedRoute == widget.menuItem[index].route
                            ? StaticColor.whiteColor
                            : StaticColor.textColor,
                        iconColor: selectedRoute == widget.menuItem[index].route
                            ? StaticColor.whiteColor
                            : StaticColor.hintColor,
                        hoverColor: StaticColor.primaryColor.withOpacity(0.3),
                        onTap: () {
                          setState(() {
                            widget.onMenuTap(widget.menuItem[index]);
                            selectedRoute = widget.menuItem[index].route;
                          });
                        },
                        title: Text(widget.menuItem[index].title,
                            style: TextStyle(fontSize: dynamicSize(.018))),
                        leading: Icon(widget.menuItem[index].leading,
                            size: dynamicSize(.028)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(flex: 10, child: widget.body)
        ],
      ),
    );
  }
}

class ScaffoldMenuItem {
  final String title;
  final String route;
  final IconData leading;

  ScaffoldMenuItem(
      {required this.title, required this.leading, required this.route});
}
