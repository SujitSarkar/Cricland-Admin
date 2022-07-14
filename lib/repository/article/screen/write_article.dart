import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricland_admin/constants/dynamic_size.dart';
import 'package:cricland_admin/constants/static_colors.dart';
import 'package:cricland_admin/constants/static_string.dart';
import 'package:cricland_admin/repository/article/controller/article_controller.dart';
import 'package:cricland_admin/widgets/loading_widget.dart';
import 'package:cricland_admin/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class WriteArticlePage extends StatelessWidget {
  const WriteArticlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ArticleController>(
      init: ArticleController(context: context),
      autoRemove: true,
      builder: (controller) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            ///Write Article Section
            Expanded(
              flex: 3,
              child: Column(
                children: const [
                  Text('Write Article Section')
                ],
              ),
            ),

            ///Category Section
            Expanded(
              flex: 1,
              child: Container(
                color: StaticColor.sideBarColor,
                padding: EdgeInsets.symmetric(horizontal: dynamicSize(0.02),vertical: dynamicSize(0.02)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${StaticString.categories}:',
                        style: TextStyle(
                            color: StaticColor.textColor,
                            fontWeight: FontWeight.bold,fontSize: dynamicSize(.022))),
                    const Divider(),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection(StaticString.categoryCollection)
                              .snapshots(),
                        builder: (context, snapshot) {
                            if(snapshot.connectionState==ConnectionState.waiting){
                              return const LoadingWidget();
                            }else if(snapshot.hasData){
                              return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder:(context, index)=>ListTile(
                                  contentPadding: const EdgeInsets.all(0.0),
                                  dense: true,
                                  title: Text('${snapshot.data!.docs[index]['category_name']}',
                                      style: TextStyle(fontSize: dynamicSize(.018),
                                          color: StaticColor.textColor)),
                                  trailing: IconButton(
                                    onPressed: (){
                                      SchedulerBinding.instance.addPostFrameCallback((_) {
                                        controller.categoryDeleteDialog(snapshot.data!.docs[index]['id']);
                                      });
                                    },
                                    icon: Icon(Icons.delete,color: StaticColor.deleteColor,
                                        size: dynamicSize(.03)),
                                  ),
                                ),
                              );
                            }else if(snapshot.data!.docs.isEmpty){
                              return const Center(child: Text('No Category Added Yet'));
                            } else{
                              return const Center(child: Text('No Category Added Yet'));
                            }

                        }
                      ),
                    ),

                    ///Add Category Section
                    Obx(() => Center(
                      child:controller.addArticle.value==false
                          ? ElevatedButton(
                          onPressed: ()=>controller.clickToAdd(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(StaticString.addNew,
                                style: TextStyle(fontSize: dynamicSize(.02))),
                          ))
                          ///Add New Category
                          :Column(
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
                                  style: ElevatedButton.styleFrom(primary: StaticColor.deleteColor),
                                    onPressed: ()=>controller.cancelAdd(),
                                    child: const Text(StaticString.cancel)),
                              ),
                              SizedBox(width: dynamicSize(.022)),
                              Expanded(
                                child: ElevatedButton(
                                    onPressed: ()=>controller.addNewCategory(),
                                    child: const Text(StaticString.add)),
                              )
                            ],
                          )
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            )
          ],
        );
      }
    );
  }
}
