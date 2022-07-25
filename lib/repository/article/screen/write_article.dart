import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricland_admin/constants/dynamic_size.dart';
import 'package:cricland_admin/constants/static_colors.dart';
import 'package:cricland_admin/constants/static_string.dart';
import 'package:cricland_admin/repository/article/controller/article_controller.dart';
import 'package:cricland_admin/repository/article/model/category_model.dart';
import 'package:cricland_admin/widgets/loading_widget.dart';
import 'package:cricland_admin/widgets/text_field_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class WriteArticlePage extends StatelessWidget {
  const WriteArticlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ArticleController>(
        init: ArticleController(context: context),
        autoRemove: true,
        builder: (controller) {
          return Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///Write Article Section
                  Expanded(
                    flex: 3,
                    child: RawKeyboardListener(
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
                                child: InkWell(
                                  onTap: () => controller.pickedImage(),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  child: Container(
                                    height: dynamicSize(0.5),
                                    width: dynamicSize(0.7),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                    ),
                                    child: controller.data != null
                                        ? Image.memory(controller.data!)
                                        : Image.asset(
                                            'assets/images/add_photo.png',
                                            height: 450,
                                            width: 650),
                                  ),
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
                                            controller
                                                .selectedCategory(newValue);
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
                                  : Center(
                                      child: ElevatedButton(
                                          onPressed: () {
                                            controller.addNewArticleWithImage();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                StaticString.saveArticle,
                                                style: TextStyle(
                                                    fontSize:
                                                        dynamicSize(.02))),
                                          )),
                                    )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  ///Category Section
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: StaticColor.sideBarColor,
                      padding: EdgeInsets.symmetric(
                          horizontal: dynamicSize(0.02),
                          vertical: dynamicSize(0.02)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${StaticString.categories}:',
                              style: TextStyle(
                                  color: StaticColor.textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: dynamicSize(.022))),
                          const Divider(),
                          Expanded(
                            child: ListView.builder(
                              itemCount: controller.categoryList.length,
                              itemBuilder: (context, index) => ListTile(
                                contentPadding: const EdgeInsets.all(0.0),
                                dense: true,
                                title: Text(
                                    controller.categoryList[index],
                                    style: TextStyle(
                                        fontSize: dynamicSize(.018),
                                        color: StaticColor.textColor)),
                                trailing: IconButton(
                                  onPressed: () {
                                    SchedulerBinding.instance
                                        .addPostFrameCallback((_) {
                                      controller.categoryDeleteDialog(
                                          controller.categoryList[index]);
                                    });
                                  },
                                  icon: Icon(Icons.delete,
                                      color: StaticColor.deleteColor,
                                      size: dynamicSize(.03)),
                                ),
                              ),
                            ),
                          ),

                          ///Add Category Section
                          Center(
                            child: controller.addArticle.value == false
                                ? ElevatedButton(
                                    onPressed: () => controller.clickToAdd(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(StaticString.addNew,
                                          style: TextStyle(
                                              fontSize: dynamicSize(.02))),
                                    ))

                                ///Add New Category
                                : Column(
                                    children: [
                                      TextFieldWidget(
                                        controller: controller.category,
                                        labelText: StaticString.writeCategory,
                                      ),
                                      SizedBox(height: dynamicSize(.022)),
                                      controller.loading.value
                                          ? const LoadingWidget()
                                          : Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary: StaticColor
                                                                  .deleteColor),
                                                      onPressed: () =>
                                                          controller
                                                              .cancelAdd(),
                                                      child: const Text(
                                                          StaticString.cancel)),
                                                ),
                                                SizedBox(
                                                    width: dynamicSize(.022)),
                                                Expanded(
                                                  child: ElevatedButton(
                                                      onPressed: () =>
                                                          controller
                                                              .addNewCategory(),
                                                      child: const Text(
                                                          StaticString.add)),
                                                )
                                              ],
                                            )
                                    ],
                                  ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ));
        });
  }
}
