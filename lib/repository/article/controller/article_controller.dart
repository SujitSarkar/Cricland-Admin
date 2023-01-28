import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricland_admin/constants/dynamic_size.dart';
import 'package:cricland_admin/constants/routes.dart';
import 'package:cricland_admin/constants/static_string.dart';
import 'package:cricland_admin/repository/article/model/article_model.dart';
import 'package:cricland_admin/repository/home/controller/home_controller.dart';
import 'package:cricland_admin/widgets/loading_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ArticleController extends GetxController {
  static final ArticleController ac = Get.find();

  late RxBool loading;
  late RxBool addArticle;
  late TextEditingController category;
  late TextEditingController title;
  late TextEditingController article;
  late TextEditingController youtubeVideoLink;

  late TextEditingController articleSearchKey;
  var uuId = const Uuid();
  late Rx<String> selectedCategory;
  late RxList<String> categoryList;
  late RxList<ArticleModel> articleList;
  late ScrollController writeArticleScrollController;
  late ScrollController articleListScrollController;

  ArticleModel updateArticleModel = ArticleModel();

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
    youtubeVideoLink = TextEditingController(text: '');
    articleSearchKey = TextEditingController(text: '');
    categoryList = <String>[].obs;
    articleList = <ArticleModel>[].obs;
    writeArticleScrollController = ScrollController();
    articleListScrollController = ScrollController();

    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
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
    youtubeVideoLink.dispose();
    articleSearchKey.dispose();
  }

  void clickToAdd() => addArticle(true);

  void cancelAdd() => addArticle(false);

  Future<void> getCategory() async {
    loading(true);
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(StaticString.categoryCollection)
          .get();
      categoryList.clear();
      for (var element in snapshot.docChanges) {
        categoryList.add(element.doc['category_name']);
      }
      categoryList.isNotEmpty
          ? selectedCategory = categoryList.first.obs
          : selectedCategory = ''.obs;
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
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(StaticString.articleCollection)
          .where('category', isEqualTo: selectedCategory.value)
          .orderBy('time_stamp', descending: true)
          .get();
      articleList.clear();
      for (var element in snapshot.docChanges) {
        ArticleModel model = ArticleModel(
          id: element.doc['id'],
          title: element.doc['title'],
          category: element.doc['category'],
          article: element.doc['article'],
          imageLink: element.doc['image_link'],
          youtubeVideoLink: element.doc['youtube_video_link'],
          timeStamp: element.doc['time_stamp'],
        );
        articleList.add(model);
      }
      if (kDebugMode) {
        print('Article Total: ${articleList.length}');
      }
      loading(false);
    } on SocketException {
      loading(false);
      showToast(StaticString.noInternet);
    } catch (error) {
      loading(false);
      showToast(error.toString());
    }
  }

  Future<void> searchArticle() async {
    loading(true);
    try {
      QuerySnapshot? snapshot;
      if (articleSearchKey.text.isEmpty) {
        snapshot = await FirebaseFirestore.instance
            .collection(StaticString.articleCollection)
            .where('category', isEqualTo: selectedCategory.value)
            .get();
      } else {
        snapshot = await FirebaseFirestore.instance
            .collection(StaticString.articleCollection)
            .where('category', isEqualTo: selectedCategory.value)
            .where('title'.toLowerCase(),
                isLessThanOrEqualTo: articleSearchKey.text.toLowerCase())
            .get();
      }

      articleList.clear();
      for (var element in snapshot.docChanges) {
        ArticleModel model = ArticleModel(
          id: element.doc['id'],
          title: element.doc['title'],
          category: element.doc['category'],
          article: element.doc['article'],
          imageLink: element.doc['image_link'],
          youtubeVideoLink: element.doc['youtube_video_link'],
          timeStamp: element.doc['time_stamp'],
        );
        articleList.add(model);
      }
      if (kDebugMode) {
        print('Article Total: ${articleList.length}');
      }
      loading(false);
    } on SocketException {
      loading(false);
      showToast(StaticString.noInternet);
    } catch (error) {
      loading(false);
      print(error.toString());
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
              .collection(StaticString.categoryCollection)
              .doc(id)
              .set({
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

  Future<void> deleteCategory(String categoryName, BuildContext context) async {
    loading(true);
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(StaticString.categoryCollection)
          .where('category_name', isEqualTo: categoryName)
          .get();
      final List<QueryDocumentSnapshot> category = snapshot.docs;

      await FirebaseFirestore.instance
          .collection(StaticString.categoryCollection)
          .doc(category.first.get('id'))
          .delete();
      showToast(StaticString.success);
      loading(false);
      await getCategory();
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } on SocketException {
      loading(false);
      showToast(StaticString.noInternet);
    } catch (error) {
      loading(false);
      showToast(error.toString());
    }
  }

  void categoryDeleteDialog(String categoryName,BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => Material(
              child: AlertDialog(
                title: const Text('Delete this category?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('NO')),
                  Obx(() => loading.value
                      ? const LoadingWidget()
                      : TextButton(
                          onPressed: () => deleteCategory(categoryName,context),
                          child: const Text('YES')))
                ],
              ),
            ));
  }

  Future<void> pickedImage() async {
    try {
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
          final stripped =
              encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
          name = input.files![0].name;
          data = base64.decode(stripped);
          error = '';
          update();
        });
      });
    } catch (error) {
      showToast(error.toString());
    }
  }

  Future<void> addNewArticleWithImage() async {
    if (data != null) {
      if (categoryList.isNotEmpty) {
        if (title.text.isNotEmpty && article.text.isNotEmpty) {
          loading(true);
          try {
            final String id = uuId.v1();
            firebase_storage.Reference storageReference = firebase_storage
                .FirebaseStorage.instance
                .ref()
                .child(StaticString.articleCollection)
                .child(id);
            firebase_storage.UploadTask storageUploadTask =
                storageReference.putBlob(file);
            firebase_storage.TaskSnapshot taskSnapshot;
            await storageUploadTask.then((value) async {
              taskSnapshot = value;
              await taskSnapshot.ref.getDownloadURL().then(
                  (newImageDownloadUrl) async {
                final String downloadUrl = newImageDownloadUrl;
                await FirebaseFirestore.instance
                    .collection(StaticString.articleCollection)
                    .doc(id)
                    .set({
                  'id': id,
                  'image_link': downloadUrl,
                  'title': title.text,
                  'article': article.text,
                  'category': selectedCategory.value,
                  'youtube_video_link': youtubeVideoLink.text,
                  'time_stamp': DateTime.now().millisecondsSinceEpoch,
                }).then((value) async {
                  title.clear();
                  article.clear();
                  data = null;
                  loading(false);
                  showToast(StaticString.success);
                });
              }, onError: (error) {
                loading(false);
                showToast(StaticString.failed);
              });
            }, onError: (error) {
              loading(false);
              showToast(StaticString.failed);
            });
          } catch (error) {
            loading(false);
            showToast(error.toString());
          }
        } else {
          showToast(StaticString.articleTitleAndContent);
        }
      } else {
        showToast(StaticString.articleCategory);
      }
    } else {
      showToast(StaticString.articlePhoto);
    }
  }

  Future<void> updateArticle() async {
    if (data != null) {
      if (title.text.isNotEmpty && article.text.isNotEmpty) {
        loading(true);
        try {
          firebase_storage.Reference storageReference = firebase_storage
              .FirebaseStorage.instance
              .ref()
              .child(StaticString.articleCollection)
              .child(updateArticleModel.id!);
          firebase_storage.UploadTask storageUploadTask =
              storageReference.putBlob(file);
          firebase_storage.TaskSnapshot taskSnapshot;
          await storageUploadTask.then((value) async {
            taskSnapshot = value;
            await taskSnapshot.ref.getDownloadURL().then(
                (newImageDownloadUrl) async {
              final String downloadUrl = newImageDownloadUrl;
              await FirebaseFirestore.instance
                  .collection(StaticString.articleCollection)
                  .doc(updateArticleModel.id!)
                  .update({
                'image_link': downloadUrl,
                'title': title.text,
                'article': article.text,
                'category': selectedCategory.value,
                'youtube_video_link': youtubeVideoLink.text,
                'time_stamp': DateTime.now().millisecondsSinceEpoch,
              }).then((value) async {
                title.clear();
                article.clear();
                data = null;
                loading(false);
                showToast(StaticString.success);
                HomeController.instance.changeCurrentScreen(Routes.articleList);
              });
            }, onError: (error) {
              loading(false);
              showToast(StaticString.failed);
            });
          }, onError: (error) {
            loading(false);
            showToast(StaticString.failed);
          });
        } catch (error) {
          loading(false);
          showToast(error.toString());
        }
      } else {
        showToast(StaticString.articleTitleAndContent);
      }
    } else {
      ///Update without image
      loading(true);
      try {
        await FirebaseFirestore.instance
            .collection(StaticString.articleCollection)
            .doc(updateArticleModel.id!)
            .update({
          'image_link': updateArticleModel.imageLink!,
          'title': title.text,
          'article': article.text,
          'category': selectedCategory.value,
          'youtube_video_link': youtubeVideoLink.text,
          'time_stamp': DateTime.now().millisecondsSinceEpoch,
        }).then((value) async {
          title.clear();
          article.clear();
          data = null;
          loading(false);
          showToast(StaticString.success);
          HomeController.instance.changeCurrentScreen(Routes.articleList);
        });
      } catch (error) {
        loading(false);
        showToast(error.toString());
      }
    }
  }

  void articleDeleteDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Delete this article?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('NO')),
                Obx(() => loading.value
                    ? const LoadingWidget()
                    : TextButton(
                        onPressed: () => deleteArticle(context),
                        child: const Text('YES')))
              ],
            ));
  }

  Future<void> deleteArticle(BuildContext context) async {
    loading(true);
    try {
      await firebase_storage.FirebaseStorage.instance
          .refFromURL(updateArticleModel.imageLink!)
          .delete();
      await FirebaseFirestore.instance
          .collection(StaticString.articleCollection)
          .doc(updateArticleModel.id!)
          .delete();
      showToast(StaticString.success);
      loading(false);
      articleList.clear();
      await getArticle();
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      HomeController.instance.changeCurrentScreen(Routes.articleList);
    } on SocketException {
      loading(false);
      showToast(StaticString.noInternet);
    } catch (error) {
      loading(false);
      showToast(error.toString());
    }
  }
}
