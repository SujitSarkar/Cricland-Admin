import 'package:cricland_admin/constants/dynamic_size.dart';
import 'package:cricland_admin/constants/static_colors.dart';
import 'package:cricland_admin/repository/article/model/article_model.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ArticleTile extends StatelessWidget {
  const ArticleTile({Key? key, required this.articleModel}) : super(key: key);
  final ArticleModel articleModel;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: StaticColor.whiteColor,
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      child: InkWell(
        onTap: (){},
        hoverColor: StaticColor.hoverColor,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.only(top:8.0,right: 20, bottom: 8.0, left: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageNetwork(
                image: articleModel.imageLink!,
                imageCache: CachedNetworkImageProvider(articleModel.imageLink!),
                height: 150,
                width: 150,
                duration: 1000,
                curve: Curves.easeIn,
                onPointer: true,
                debugPrint: false,
                fullScreen: false,
                fitAndroidIos: BoxFit.cover,
                fitWeb: BoxFitWeb.cover,
                borderRadius: BorderRadius.circular(5),
                onLoading: const CircularProgressIndicator(
                  color: Colors.indigoAccent,
                ),
                onError: const Icon(
                  Icons.error,
                  color: Colors.red,
                )
              ),
              SizedBox(width: dynamicSize(0.02)),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(articleModel.title!, maxLines: 1,style: TextStyle(
                      fontSize: dynamicSize(.022),
                      fontWeight: FontWeight.bold,
                      color: StaticColor.textColor
                    )),
                    Text(articleModel.article!,
                        textAlign: TextAlign.justify,
                        maxLines: 5,
                        style: TextStyle(
                        fontSize: dynamicSize(.02),
                        color: StaticColor.hintColor,
                    ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
