import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricland_admin/constants/dynamic_size.dart';
import 'package:cricland_admin/constants/static_string.dart';
import 'package:cricland_admin/repository/article/model/article_model.dart';
import 'package:cricland_admin/repository/article/model/category_model.dart';
import 'package:cricland_admin/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'dart:html' as html;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ArticleController extends GetxController {
  ArticleController({required this.context});
  BuildContext context;

  late RxBool loading;
  late RxBool addArticle;
  late TextEditingController category;
  late TextEditingController title;
  late TextEditingController article;
  late TextEditingController articleSearchKey;
  var uuId = const Uuid();
  late Rx<CategoryModel> selectedCategory;
  late RxList<CategoryModel> categoryList;
  late RxList<ArticleModel> articleList;
  late ScrollController writeArticleScrollController;
  late ScrollController articleListScrollController;

  String name = '';
  Uint8List? data;
  late var file;
  late String error;

  @override
  void onInit() {
    super.onInit();
    loading = false.obs;
    addArticle = false.obs;
    category = TextEditingController(text: '');
    title = TextEditingController(text: '');
    article = TextEditingController(text: '');
    articleSearchKey = TextEditingController(text: '');
    categoryList = <CategoryModel>[].obs;
    articleList = <ArticleModel>[].obs;
    writeArticleScrollController = ScrollController();
    articleListScrollController = ScrollController();

    fetchInitialData();
  }

  Future<void> fetchInitialData()async{
    await getCategory();
    await getArticle();
  }

  @override
  void dispose() {
    super.dispose();
    loading.close();
    addArticle.close();
    category.dispose();
    title.dispose();
    article.dispose();
    articleSearchKey.dispose();
  }

  void clickToAdd() => addArticle(true);

  void cancelAdd() => addArticle(false);

  Future<void> getCategory() async {
    loading(true);
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(StaticString.categoryCollection).get();
      categoryList.clear();
      for (var element in snapshot.docChanges) {
        CategoryModel model = CategoryModel(
          id: element.doc['id'],
          category: element.doc['category_name']
        );
        categoryList.add(model);
      }
      categoryList.isNotEmpty
          ?selectedCategory = categoryList.first.obs
          :selectedCategory =CategoryModel().obs;
      loading(false);
    } on SocketException {
      loading(false);
      showToast(StaticString.noInternet);
    } catch (error) {
      loading(false);
      showToast(error.toString());
    }
  }

  Future<void> getArticle() async {
    loading(true);
    try {
      QuerySnapshot snapshot;
      if(articleList.isEmpty){
        snapshot = await FirebaseFirestore.instance
            .collection(StaticString.articleCollection).orderBy('time_stamp',
            descending: true).limit(30).get();
      }else{
        snapshot = await FirebaseFirestore.instance
            .collection(StaticString.articleCollection).where('time_stamp',
            isGreaterThan: articleList.last.timeStamp).orderBy('time_stamp',
            descending: true).limit(10).get();
      }
      
      for (var element in snapshot.docChanges) {
        ArticleModel model = ArticleModel(
          id: element.doc['id'],
          title: element.doc['title'],
          category: element.doc['category'],
          article: element.doc['article'],
          imageLink: element.doc['image_link'],
          timeStamp: element.doc['time_stamp'],
        );
        articleList.add(model);
      }
      print('Article Total: ${articleList.length}');
      loading(false);
    } on SocketException {
      loading(false);
      showToast(StaticString.noInternet);
    } catch (error) {
      loading(false);
      showToast(error.toString());
    }
  }

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
              .collection(StaticString.categoryCollection).doc(id).set({
            'id': id,
            'category_name': category.text,
            'time_stamp': DateTime.now().millisecondsSinceEpoch
          });
          showToast(StaticString.success);
          await getCategory();
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
      await getCategory();
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

  Future<void> pickedImage() async {
    try{
      html.FileUploadInputElement input = html.FileUploadInputElement()
        ..accept = 'image/*';
      input.click();
      input.onChange.listen((event) {
        file = input.files!.first;
        final reader1 = html.FileReader();
        reader1.readAsDataUrl(input.files![0]);
        reader1.onError.listen((err) => error = err.toString());
        reader1.onLoad.first.then((res) {
          final encoded = reader1.result as String;
          final stripped = encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
          name = input.files![0].name;
          data = base64.decode(stripped);
          error = '';
          update();
        });
      });
    }catch(error){
      showToast(error.toString());
    }
  }

  Future<void> addNewArticleWithImage() async {
    if(data!=null){
      if(categoryList.isNotEmpty){
        if(title.text.isNotEmpty && article.text.isNotEmpty){
          loading(true);
          try{
            final String id = uuId.v1();
            firebase_storage.Reference storageReference = firebase_storage
                .FirebaseStorage.instance.ref()
                .child(StaticString.articleCollection).child(id);
            firebase_storage.UploadTask storageUploadTask =
            storageReference.putBlob(file);
            firebase_storage.TaskSnapshot taskSnapshot;
            await storageUploadTask.then((value) async {
              taskSnapshot = value;
              await taskSnapshot.ref.getDownloadURL().then((newImageDownloadUrl)
              async {
                final String downloadUrl = newImageDownloadUrl;
                await FirebaseFirestore.instance
                    .collection(StaticString.articleCollection).doc(id).set({
                  'id': id,
                  'image_link': downloadUrl,
                  'title': title.text,
                  'article': article.text,
                  'category': selectedCategory.value.category,
                  'time_stamp': DateTime.now().millisecondsSinceEpoch,
                }).then((value) async {
                  title.clear();
                  article.clear();
                  data=null;
                  loading(false);
                  showToast(StaticString.success);
                });
              },onError: (error) {
                loading(false);
                showToast(StaticString.failed);
              });
            },onError: (error) {
              loading(false);
              showToast(StaticString.failed);
            });
          }catch(error){
            loading(false);
            showToast(error.toString());
          }
        }else{showToast(StaticString.articleTitleAndContent);}
      }else{showToast(StaticString.articleCategory);}
    }else{showToast(StaticString.articlePhoto);}
  }
}
