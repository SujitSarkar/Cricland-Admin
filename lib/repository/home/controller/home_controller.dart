import 'package:cricland_admin/constants/routes.dart';
import 'package:cricland_admin/repository/article/screen/article_list.dart';
import 'package:cricland_admin/repository/article/screen/write_article.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController{

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
}