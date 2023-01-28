import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricland_admin/constants/dynamic_size.dart';
import 'package:cricland_admin/constants/routes.dart';
import 'package:cricland_admin/constants/static_string.dart';
import 'package:cricland_admin/repository/home/controller/home_controller.dart';
import 'package:cricland_admin/repository/package/model/package_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class PackageController extends GetxController {
  static final PackageController pc = Get.find();

  late RxBool loading;
  late TextEditingController packageName;
  late TextEditingController packagePrice;
  late TextEditingController discountAmount;
  late TextEditingController packageDuration;
  late TextEditingController hexColorController;
  var uuId = const Uuid();
  late ScrollController packageListScrollController;
  late String pickerColorCode;
  late Rx<Color> pickerColor;
  late RxList<PackageModel> packageList;
  late String packageId;

  @override
  void onInit() {
    super.onInit();
    loading = false.obs;
    packageName = TextEditingController();
    packagePrice = TextEditingController();
    discountAmount = TextEditingController();
    packageDuration = TextEditingController();
    packageListScrollController = ScrollController();
    pickerColorCode = "0xFFFD650D";
    pickerColor = Rx(const Color(0xFFFD650D));
    hexColorController = TextEditingController(text: pickerColorCode);
    packageList = <PackageModel>[].obs;

    getPackage();
  }

  void colorPickerOnChange() {
    pickerColorCode = '0x${hexColorController.text}';
    pickerColor(Color(int.parse(pickerColorCode)));
  }

  void updateButtonOnTap(PackageModel model) {
    packageId = model.id!;
    packageName = TextEditingController(text: model.packageName);
    packagePrice = TextEditingController(text: model.packagePrice.toString());
    discountAmount = model.discountAmount != null
        ? TextEditingController(text: model.discountAmount.toString())
        : TextEditingController();
    packageDuration =
        TextEditingController(text: model.packageDuration.toString());
    pickerColorCode = model.colorCode!;
    pickerColor = Rx(Color(int.parse(pickerColorCode)));
    hexColorController = TextEditingController(text: pickerColorCode);
    HomeController.instance.changeCurrentScreen(Routes.updatePackage);
  }

  Future<void> addPackage() async {
    if (packageName.text.isNotEmpty &&
        packagePrice.text.isNotEmpty &&
        packageDuration.text.isNotEmpty) {
      try {
        loading(true);
        final String id = uuId.v1();
        await FirebaseFirestore.instance
            .collection(StaticString.packageCollection)
            .doc(id)
            .set({
          'id': id,
          'package_name': packageName.text,
          'package_price': double.parse(packagePrice.text),
          'package_duration': int.parse(packageDuration.text),
          'discount_amount': discountAmount.text.isNotEmpty
              ? double.parse(discountAmount.text)
              : null,
          'color_code': pickerColorCode,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        });
        await getPackage();
        loading(false);
        showToast(StaticString.success);
        packageName.clear();
        packagePrice.clear();
        packageDuration.clear();
        discountAmount.clear();
      } on SocketException {
        showToast(StaticString.noInternet);
        loading(false);
      } catch (error) {
        loading(false);
        showToast(error.toString());
      }
    } else {
      showToast(StaticString.emptyField);
    }
  }

  Future<void> updatePackage() async {
    if (packageName.text.isNotEmpty &&
        packagePrice.text.isNotEmpty &&
        packageDuration.text.isNotEmpty) {
      try {
        loading(true);
        await FirebaseFirestore.instance
            .collection(StaticString.packageCollection)
            .doc(packageId)
            .update({
          'package_name': packageName.text,
          'package_price': double.parse(packagePrice.text),
          'package_duration': int.parse(packageDuration.text),
          'discount_amount': discountAmount.text.isNotEmpty
              ? double.parse(discountAmount.text)
              : null,
          'color_code': pickerColorCode,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        });
        await getPackage();
        loading(false);
        showToast(StaticString.success);
        packageName.clear();
        packagePrice.clear();
        packageDuration.clear();
        discountAmount.clear();
        HomeController.instance.changeCurrentScreen(Routes.package);
      } on SocketException {
        showToast(StaticString.noInternet);
        loading(false);
      } catch (error) {
        loading(false);
        showToast(error.toString());
      }
    } else {
      showToast(StaticString.emptyField);
    }
  }

  Future<void> getPackage() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(StaticString.packageCollection)
          .orderBy('timestamp', descending: true)
          .get();
      packageList.clear();
      for (var element in snapshot.docChanges) {
        PackageModel model = PackageModel(
          id: element.doc['id'],
          packageName: element.doc['package_name'],
          packagePrice: element.doc['package_price'],
          packageDuration: element.doc['package_duration'],
          discountAmount: element.doc['discount_amount'],
          colorCode: element.doc['color_code'],
          timeStamp: element.doc['timestamp'],
        );
        packageList.add(model);
      }
      if (kDebugMode) {
        print('Package Total: ${packageList.length}');
      }
    } on SocketException {
      showToast(StaticString.noInternet);
    } catch (error) {
      showToast(error.toString());
    }
  }

  Future<void> deletePackage(String id) async {
    try {
      loading(true);
      await FirebaseFirestore.instance
          .collection(StaticString.packageCollection)
          .doc(id)
          .delete();
      await getPackage();
      loading(false);
      showToast("Successfully deleted");
    } on SocketException {
      loading(false);
      showToast('No internet connection');
    } catch (error) {
      loading(false);
      showToast(error.toString());
    }
  }
}
