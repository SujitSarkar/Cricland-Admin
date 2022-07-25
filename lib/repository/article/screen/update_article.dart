import 'package:cached_network_image/cached_network_image.dart';
import 'package:cricland_admin/constants/dynamic_size.dart';
import 'package:cricland_admin/constants/static_colors.dart';
import 'package:cricland_admin/constants/static_string.dart';
import 'package:cricland_admin/repository/article/controller/article_controller.dart';
import 'package:cricland_admin/widgets/loading_widget.dart';
import 'package:cricland_admin/widgets/text_field_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';

class UpdateArticlePage extends StatelessWidget {
  const UpdateArticlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ArticleController>(
        init: ArticleController(context: context),
        autoRemove: true,
        builder: (controller) {
          return Obx(() => RawKeyboardListener(
            focusNode: FocusNode(),
            autofocus: true,
            onKey: (event) {
              var offset =
                  controller.writeArticleScrollController.offset;
              if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
                if (kReleaseMode) {
                  controller.writeArticleScrollController.animateTo(
                      offset - 100,
                      duration: const Duration(milliseconds: 30),
                      curve: Curves.ease);
                } else {
                  controller.writeArticleScrollController.animateTo(
                      offset - 100,
                      duration: const Duration(milliseconds: 30),
                      curve: Curves.ease);
                }
              } else if (event.logicalKey ==
                  LogicalKeyboardKey.arrowDown) {
                if (kReleaseMode) {
                  controller.writeArticleScrollController.animateTo(
                      offset + 100,
                      duration: const Duration(milliseconds: 30),
                      curve: Curves.ease);
                } else {
                  controller.writeArticleScrollController.animateTo(
                      offset + 100,
                      duration: const Duration(milliseconds: 30),
                      curve: Curves.ease);
                }
              }
            },
            child: Scrollbar(
              trackVisibility: true,
              thumbVisibility: true,
              controller: controller.writeArticleScrollController,
              child: SingleChildScrollView(
                controller: controller.writeArticleScrollController,
                padding: EdgeInsets.all(dynamicSize(0.03)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///Article Image
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          InkWell(
                            onTap: () => controller.pickedImage(),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(5)),
                            child: Container(
                              alignment: Alignment.center,
                              height: dynamicSize(0.5),
                              width: dynamicSize(0.7),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(5)),
                              ),
                              child: InkWell(
                                onTap: () => controller.pickedImage(),
                                child: controller.data != null
                                    ? Image.memory(controller.data!)
                                    : ImageNetwork(
                                    image: controller.updateArticleModel.imageLink!,
                                    imageCache: CachedNetworkImageProvider(controller.updateArticleModel.imageLink!),
                                    height: 450,
                                    width: 650,
                                    duration: 1000,
                                    curve: Curves.easeIn,
                                    onPointer: true,
                                    debugPrint: false,
                                    fullScreen: false,
                                    fitAndroidIos: BoxFit.contain,
                                    fitWeb: BoxFitWeb.contain,
                                    borderRadius: BorderRadius.circular(5),
                                    onLoading: const CircularProgressIndicator(
                                      color: Colors.indigoAccent,
                                    ),
                                    onError: const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    )
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0.0,
                            right: 0.0,
                            child: IconButton(
                              onPressed: ()=>controller.pickedImage(),
                              icon: const Icon(Icons.add_a_photo,
                                  color: StaticColor.primaryColor),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: dynamicSize(0.03)),

                    controller.loading.value
                        ? const LoadingWidget()
                        : Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: dynamicSize(.02)),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: StaticColor.primaryColor,
                              width: 0.5),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(5))),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value:
                          controller.selectedCategory.value,
                          elevation: 0,
                          dropdownColor: StaticColor.whiteColor,
                          onChanged: (newValue) {
                            controller.selectedCategory(newValue);
                          },
                          items: controller.categoryList.map<
                              DropdownMenuItem<
                                  String>>(
                                  (String value) {
                                return DropdownMenuItem<
                                    String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: dynamicSize(0.03)),

                    TextFieldWidget(
                      controller: controller.title,
                      labelText: StaticString.articleTitle,
                    ),
                    SizedBox(height: dynamicSize(0.03)),

                    TextFieldWidget(
                      controller: controller.article,
                      labelText: StaticString.articleContent,
                      maxLine: 20,
                      minLine: 20,
                    ),
                    SizedBox(height: dynamicSize(0.03)),

                    controller.loading.value
                        ? const LoadingWidget()
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () async{
                                  controller.articleDeleteDialog(context);
                                },
                                style: ElevatedButton.styleFrom(primary: StaticColor.deleteColor),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      StaticString.delete,
                                      style: TextStyle(
                                          fontSize:
                                          dynamicSize(.02))),
                                )),
                            SizedBox(width: dynamicSize(.04)),

                            ElevatedButton(
                                onPressed: () async{
                                  await controller.updateArticle();
                                  await controller.getArticle();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      StaticString.update,
                                      style: TextStyle(
                                          fontSize:
                                          dynamicSize(.02))),
                                )),
                          ],
                        )
                  ],
                ),
              ),
            ),
          ));
        });
  }
}
