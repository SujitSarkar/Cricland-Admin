import 'package:cricland_admin/constants/routes.dart';
import 'package:cricland_admin/repository/article/screen/article_list.dart';
import 'package:cricland_admin/repository/article/screen/write_article.dart';
import 'package:cricland_admin/repository/home/screen/home_screen.dart';
import 'package:cricland_admin/repository/login/screen/login_screen.dart';
import 'package:flutter/material.dart';

class Pages {
  static Map<String, Widget Function(BuildContext)> pages(
          BuildContext context) => {
        Routes.login: (context) => const LoginScreen(),
        Routes.home: (context) => const HomeScreen(),
        Routes.articleList: (context) => const ArticleListPage(),
        Routes.writeArticle: (context) => const WriteArticlePage(),
      };
}
