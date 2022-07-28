import 'package:cricland_admin/constants/dynamic_size.dart';
import 'package:cricland_admin/constants/static_colors.dart';
import 'package:cricland_admin/constants/static_string.dart';
import 'package:cricland_admin/repository/article/controller/article_controller.dart';
import 'package:cricland_admin/repository/article/tiles/article_tile.dart';
import 'package:cricland_admin/widgets/loading_widget.dart';
import 'package:cricland_admin/widgets/text_field_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ArticleListPage extends StatefulWidget {
  const ArticleListPage({Key? key}) : super(key: key);

  @override
  State<ArticleListPage> createState() => _ArticleListPageState();
}

class _ArticleListPageState extends State<ArticleListPage> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ArticleController>(
      init: ArticleController(context: context),
      builder: (controller)=> Obx(()=> controller.loading.value
          ? const LoadingWidget()
          : Padding(
        padding: EdgeInsets.all(dynamicSize(0.03)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///Article Category
                Container(
                  padding: EdgeInsets.symmetric(horizontal: dynamicSize(.02)),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: StaticColor.primaryColor, width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: controller.selectedCategory.value,
                      elevation: 0,
                      dropdownColor: StaticColor.whiteColor,
                      onChanged: (newValue) {
                        controller.selectedCategory(newValue);
                      },
                      items: controller.categoryList
                          .map<DropdownMenuItem<String>>(
                              (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                    ),
                  ),
                ),
                SizedBox(width: dynamicSize(.02)),

                ///Search Field
                Expanded(
                  child: TextFieldWidget(
                    controller: controller.articleSearchKey,
                    labelText: StaticString.searchArticle,
                  ),
                ),
                SizedBox(width: dynamicSize(.02)),

                ElevatedButton(
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                      child: Row(
                        children: [
                          Icon(Icons.search,
                              color: StaticColor.whiteColor,
                              size: dynamicSize(.03)),
                          SizedBox(width: dynamicSize(.02)),
                          Text('Search',
                              style: TextStyle(
                                  fontSize: dynamicSize(.022),
                                  color: StaticColor.whiteColor))
                        ],
                      ),
                    ))
              ],
            ),
            SizedBox(height: dynamicSize(0.03)),

            Expanded(
              child: RawKeyboardListener(
                focusNode: FocusNode(),
                autofocus: true,
                onKey: (event) {
                  var offset =
                      controller.articleListScrollController.offset;
                  if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
                    if (kReleaseMode) {
                      controller.articleListScrollController.animateTo(
                          offset - 100,
                          duration: const Duration(milliseconds: 30),
                          curve: Curves.ease);
                    } else {
                      controller.articleListScrollController.animateTo(
                          offset - 100,
                          duration: const Duration(milliseconds: 30),
                          curve: Curves.ease);
                    }
                  } else if (event.logicalKey ==
                      LogicalKeyboardKey.arrowDown) {
                    if (kReleaseMode) {
                      controller.articleListScrollController.animateTo(
                          offset + 100,
                          duration: const Duration(milliseconds: 30),
                          curve: Curves.ease);
                    } else {
                      controller.articleListScrollController.animateTo(
                          offset + 100,
                          duration: const Duration(milliseconds: 30),
                          curve: Curves.ease);
                    }
                  }
                },
                child: Scrollbar(
                  trackVisibility: true,
                  thumbVisibility: true,
                  controller: controller.articleListScrollController,
                  child: ListView.builder(
                    controller: controller.articleListScrollController,
                    itemCount: controller.articleList.length,
                    itemBuilder: (context,index)=>ArticleTile(articleModel: controller.articleList[index]),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
