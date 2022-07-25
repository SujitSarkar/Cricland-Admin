import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricland_admin/constants/dynamic_size.dart';
import 'package:cricland_admin/constants/routes.dart';
import 'package:cricland_admin/constants/static_string.dart';
import 'package:cricland_admin/repository/home/controller/home_controller.dart';
import 'package:cricland_admin/repository/home/screen/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController{
  LoginController({required this.context});
  late BuildContext context;
  late RxBool loading;
  late TextEditingController username;
  late TextEditingController password;

  @override
  void onInit() {
    super.onInit();

    loading = false.obs;
    username = TextEditingController(text: '');
    password = TextEditingController(text: '');
    autoLogin();
  }

  @override
  void dispose() {
    super.dispose();
    username.dispose();
    password.dispose();
    loading.close();
  }


  Future<void> validateAdmin()async{
    loading(true);
    try{
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(StaticString.adminCollection)
          .where('username', isEqualTo: username.text).get();
      final List<QueryDocumentSnapshot> user = snapshot.docs;
      if(user.isNotEmpty && user.first.get('password')==password.text){
        HomeController.instance.setData('username', username.text);
        HomeController.instance.setData('password', password.text);
        loading(false);
        Navigator.pushReplacementNamed(context, Routes.home);
      }else{
        loading(false);
        showToast(StaticString.wrongUserPass);
      }
    }
    on SocketException{
      loading(false);
      showToast(StaticString.noInternet);
    }
    catch(error){
      loading(false);
      showToast(error.toString());
    }
  }

  Future<void> autoLogin()async{
    if(HomeController.instance.getString('username')!=null &&
        HomeController.instance.getString('password')!=null){
      loading(true);
      try{
        QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(StaticString.adminCollection)
            .where('username', isEqualTo:HomeController.instance.getString('username')).get();
        final List<QueryDocumentSnapshot> user = snapshot.docs;
        if(user.isNotEmpty && user.first.get('password')
            ==HomeController.instance.getString('password')){
          loading(false);
          //Navigator.pushReplacementNamed(context, Routes.home);
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              const HomeScreen()), (Route<dynamic> route) => false);
        }else{
          loading(false);
          showToast(StaticString.wrongUserPass);
        }
      } on SocketException{
        loading(false);
        showToast(StaticString.noInternet);
      } catch(error){
        loading(false);
        showToast(error.toString());
      }
    }
  }
}