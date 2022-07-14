import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricland_admin/constants/dynamic_size.dart';
import 'package:cricland_admin/constants/static_string.dart';
import 'package:cricland_admin/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ArticleController extends GetxController {
  ArticleController({required this.context});

  BuildContext context;

  late RxBool loading;
  late RxBool addArticle;
  late TextEditingController category;
  var uuId = const Uuid();

  @override
  void onInit() {
    super.onInit();

    loading = false.obs;
    addArticle = false.obs;
    category = TextEditingController(text: '');
  }

  @override
  void dispose() {
    super.dispose();
    loading.close();
    addArticle.close();
    category.dispose();
  }

  void clickToAdd() => addArticle(true);

  void cancelAdd() => addArticle(false);

  Future<void> addNewCategory() async {
    if (category.text.isNotEmpty && loading.value == false) {
      loading(true);
      try {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection(StaticString.categoryCollection)
            .where('category_name', isEqualTo: category.text)
            .get();
        final List<QueryDocumentSnapshot> categories = snapshot.docs;
        if (categories.isEmpty) {
          final String id = uuId.v1();
          await FirebaseFirestore.instance
              .collection(StaticString.categoryCollection)
              .doc(id)
              .set({
            'id': id,
            'category_name': category.text,
            'time_stamp': DateTime.now().millisecondsSinceEpoch
          });
          showToast(StaticString.success);
          loading(false);
          category.clear();
        } else {
          loading(false);
          showToast(StaticString.alreadyExist);
        }
      } on SocketException {
        loading(false);
        showToast(StaticString.noInternet);
      } catch (error) {
        loading(false);
        showToast(error.toString());
      }
    } else {
      showToast(StaticString.emptyField);
    }
  }

  Future<void> deleteCategory(String id) async {
    loading(true);
    try {
      await FirebaseFirestore.instance
          .collection(StaticString.categoryCollection)
          .doc(id)
          .delete();
      showToast(StaticString.success);
      loading(false);
      Navigator.pop(context);
    } on SocketException {
      loading(false);
      showToast(StaticString.noInternet);
    } catch (error) {
      loading(false);
      showToast(error.toString());
    }
  }

  void categoryDeleteDialog(String id){
    showDialog(
        context: context,
        builder: (_)=>AlertDialog(
          title: const Text('Delete this category?'),
          actions: [
           TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('NO')),
           Obx(() => loading.value? const LoadingWidget()
               : TextButton(onPressed: ()=>deleteCategory(id), child: const Text('YES')))
          ],
        ));
  }
}
