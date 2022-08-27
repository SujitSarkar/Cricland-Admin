import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

double dynamicSize(double size)=> Get.size.width>=500?Get.size.height*size:Get.size.width*size;

final double getHeight =Get.size.height;
final double getWidth =Get.size.width;

void showToast(String mgs)=>Fluttertoast.showToast(
    msg: mgs,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black87,
    textColor: Colors.white,
    fontSize: dynamicSize(.045)
);