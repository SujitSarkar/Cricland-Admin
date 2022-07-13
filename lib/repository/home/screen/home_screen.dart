import 'package:cricland_admin/constants/routes.dart';
import 'package:cricland_admin/constants/string_constant.dart';
import 'package:cricland_admin/repository/home/controller/home_controller.dart';
import 'package:cricland_admin/widgets/admin_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        autoRemove: false,
        builder: (homeController) {
          return AdminScaffold(
            menuItem: [
              ScaffoldMenuItem(
                  title: 'Article List',
                  leading: Icons.article,
                  route: Routes.articleList),
              ScaffoldMenuItem(
                  title: 'Write Article',
                  leading: Icons.edit_note,
                  route: Routes.writeArticle),
            ],
            onMenuTap: (ScaffoldMenuItem val) {
              homeController.changeCurrentScreen(val.route);
            },
            title: StringConstant.appName,
            body: homeController.homeWidget,
          );
        });
  }
}
