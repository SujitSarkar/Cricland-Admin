import 'package:cricland_admin/constants/dynamic_size.dart';
import 'package:cricland_admin/constants/static_colors.dart';
import 'package:cricland_admin/constants/static_string.dart';
import 'package:cricland_admin/repository/article/controller/article_controller.dart';
import 'package:cricland_admin/repository/article/model/category_model.dart';
import 'package:cricland_admin/repository/article/tiles/article_tile.dart';
import 'package:cricland_admin/widgets/loading_widget.dart';
import 'package:cricland_admin/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArticleListPage extends StatelessWidget {
  const ArticleListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ArticleController>(
      init: ArticleController(context: context),
      builder: (controller) =>Obx(() => controller.loading.value
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
                    child: DropdownButton<CategoryModel>(
                      value: controller.selectedCategory.value,
                      elevation: 0,
                      dropdownColor: StaticColor.whiteColor,
                      onChanged: (newValue) {
                        controller.selectedCategory(newValue);
                      },
                      items: controller.categoryList
                          .map<DropdownMenuItem<CategoryModel>>(
                              (CategoryModel model) {
                            return DropdownMenuItem<CategoryModel>(
                              value: model,
                              child: Text(model.category!),
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
              child: Scrollbar(
                trackVisibility: true,
                thumbVisibility: true,
                controller: controller.articleListScrollController,
                child: ListView.separated(
                  controller: controller.articleListScrollController,
                  shrinkWrap: true,
                  itemCount: controller.articleList.length,
                  itemBuilder: (context,index)=>ArticleTile(articleModel: controller.articleList[index]),
                  separatorBuilder: (context,index)=>SizedBox(height: dynamicSize(.02)),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
