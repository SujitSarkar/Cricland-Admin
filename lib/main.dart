import 'package:cricland_admin/constants/routes.dart';
import 'package:cricland_admin/constants/static_string.dart';
import 'package:cricland_admin/constants/static_variavles.dart';
import 'package:cricland_admin/repository/article/controller/article_controller.dart';
import 'package:cricland_admin/repository/article/screen/article_list.dart';
import 'package:cricland_admin/repository/article/screen/update_article.dart';
import 'package:cricland_admin/repository/article/screen/write_article.dart';
import 'package:cricland_admin/repository/home/screen/home_screen.dart';
import 'package:cricland_admin/repository/login/screen/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: kIsWeb? const FirebaseOptions(
        apiKey: "AIzaSyAXH46EheF_v8Sb0mzXB3ye-gwNkLraG7o",
        authDomain: "cricland.firebaseapp.com",
        projectId: "cricland",
        storageBucket: "cricland.appspot.com",
        messagingSenderId: "788456208019",
        appId: "1:788456208019:web:3fe44b77e8b2d5186d3f66",
        measurementId: "G-ZP68ED6LGD"
    ):null,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(ArticleController(context: context));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: StaticString.appName,
      theme:StaticVar.themeData,
      initialRoute: Routes.login,
      routes: {
        Routes.login: (context) => const LoginScreen(),
        Routes.home: (context) => const HomeScreen(),
        Routes.articleList: (context) => const ArticleListPage(),
        Routes.writeArticle: (context) => const WriteArticlePage(),
        Routes.updateArticle: (context) => const UpdateArticlePage(),
      },
    );
  }
}
