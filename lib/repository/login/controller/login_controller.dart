import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricland_admin/constants/dynamic_size.dart';
import 'package:cricland_admin/constants/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController{
  LoginController({required this.context});
  late BuildContext context;
  Rx<bool> loading=false.obs;
  late TextEditingController username;
  late TextEditingController password;

  @override
  void onInit() {
    super.onInit();
    username = TextEditingController(text: '');
    password = TextEditingController(text: '');
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
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('admin')
          .where('username', isEqualTo: username.text).get();
      final List<QueryDocumentSnapshot> user = snapshot.docs;
      if(user.isNotEmpty && user.first.get('password')==password.text){
        loading(false);
        Navigator.pushReplacementNamed(context, Routes.home);
      }else{
        loading(false);
        showToast('Wrong Username or Password');
      }
    }
    on SocketException{
      loading(false);
      showToast('No Internet Connection !');
    }
    catch(error){
      loading(false);
      showToast(error.toString());
    }
  }
}