import 'package:cricland_admin/constants/routes.dart';
import 'package:cricland_admin/repository/article/screen/article_list.dart';
import 'package:cricland_admin/repository/article/screen/write_article.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController{
  static final HomeController instance = Get.find();
  Widget homeWidget=const ArticleListPage();

  @override
  void onInit() {
    super.onInit();
  }

  void changeCurrentScreen(String route){
    switch(route){
      case Routes.articleList: homeWidget=const ArticleListPage();
      update();
      break;
      case Routes.writeArticle: homeWidget=const WriteArticlePage();
      update();
      break;
      default: homeWidget=const WriteArticlePage();
      update();
      break;
    }
  }




  void setData(String key, dynamic value) async=>await GetStorage().write(key, value);
  int? getInt(String key) => GetStorage().read(key);
  String? getString(String key) => GetStorage().read(key);
  bool? getBool(String key) => GetStorage().read(key);
  double? getDouble(String key) => GetStorage().read(key);
  dynamic getData(String key) => GetStorage().read(key);
  void clearData() async => await GetStorage().erase();
}