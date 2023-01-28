import 'package:cricland_admin/constants/dynamic_size.dart';
import 'package:cricland_admin/constants/static_string.dart';
import 'package:cricland_admin/repository/package/controller/package_controller.dart';
import 'package:cricland_admin/repository/package/model/package_model.dart';
import 'package:cricland_admin/widgets/loading_widget.dart';
import 'package:cricland_admin/widgets/text_field_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

class AddPackage extends StatelessWidget {
  const AddPackage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PackageController>(
        init: PackageController(),
        autoRemove: false,
        builder: (controller) {
          return Obx(
            () => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///Add Package
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(dynamicSize(0.03)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///Package Name
                        TextFieldWidget(
                          controller: controller.packageName,
                          labelText: StaticString.packageName,
                          textCapitalization: TextCapitalization.words,
                        ),
                        SizedBox(height: dynamicSize(0.03)),

                        ///Package Price
                        Row(
                          children: [
                            Expanded(
                              child: TextFieldWidget(
                                controller: controller.packagePrice,
                                labelText: StaticString.packagePrice,
                                textInputType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                              ),
                            ),
                            SizedBox(width: dynamicSize(0.03)),

                            ///Discount Price
                            Expanded(
                              child: TextFieldWidget(
                                controller: controller.discountAmount,
                                labelText: StaticString.discountAmount,
                                textInputType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: dynamicSize(0.03)),

                        ///Package Duration
                        TextFieldWidget(
                          controller: controller.packageDuration,
                          labelText: "${StaticString.packageDuration} in Month",
                          textInputType: const TextInputType.numberWithOptions(
                              decimal: true),
                        ),

                        SizedBox(height: dynamicSize(0.03)),
                        Row(
                          children: [
                            const Expanded(
                                child: Text('Selected Package Color:',
                                    textAlign: TextAlign.start)),
                            InkWell(
                              onTap: () => showColorDialog(context, controller),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: controller.pickerColor.value,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child:
                                    Text(controller.pickerColorCode.toString()),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: dynamicSize(0.03)),

                        controller.loading.value
                            ? const LoadingWidget()
                            : Center(
                                child: ElevatedButton(
                                    onPressed: () async {
                                      await controller.addPackage();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(StaticString.addPackage,
                                          style: TextStyle(
                                              fontSize: dynamicSize(.02))),
                                    )),
                              )
                      ],
                    ),
                  ),
                ),

                ///Package List
                Expanded(
                  child: RawKeyboardListener(
                    focusNode: FocusNode(),
                    autofocus: true,
                    onKey: (event) {
                      var offset =
                          controller.packageListScrollController.offset;
                      if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
                        if (kReleaseMode) {
                          controller.packageListScrollController.animateTo(
                              offset - 100,
                              duration: const Duration(milliseconds: 30),
                              curve: Curves.ease);
                        } else {
                          controller.packageListScrollController.animateTo(
                              offset - 100,
                              duration: const Duration(milliseconds: 30),
                              curve: Curves.ease);
                        }
                      } else if (event.logicalKey ==
                          LogicalKeyboardKey.arrowDown) {
                        if (kReleaseMode) {
                          controller.packageListScrollController.animateTo(
                              offset + 100,
                              duration: const Duration(milliseconds: 30),
                              curve: Curves.ease);
                        } else {
                          controller.packageListScrollController.animateTo(
                              offset + 100,
                              duration: const Duration(milliseconds: 30),
                              curve: Curves.ease);
                        }
                      }
                    },
                    child: Scrollbar(
                      trackVisibility: true,
                      thumbVisibility: true,
                      controller: controller.packageListScrollController,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(20),
                        controller: controller.packageListScrollController,
                        itemCount: controller.packageList.length,
                        itemBuilder: (context, index) => PackageCardTile(
                            model: controller.packageList[index]),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  void showColorDialog(BuildContext context, PackageController controller) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: controller.pickerColor.value,
            onColorChanged: (Color changeColor) =>
                controller.colorPickerOnChange(),
            hexInputBar: true,
            hexInputController: controller.hexColorController,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class PackageCardTile extends StatelessWidget {
  PackageCardTile({super.key, required this.model});
  final PackageModel model;

  final TextStyle _textStyle =
      TextStyle(fontSize: dynamicSize(.032), color: Colors.black);
  double price = 0.0;
  double discountPercent = 0.0;

  @override
  Widget build(BuildContext context) {
    if (model.discountAmount != null) {
      price = model.packagePrice! - model.discountAmount!;
      discountPercent = (100 / (model.packagePrice! / model.discountAmount!));
    } else {
      price = model.packagePrice!;
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.symmetric(
                horizontal: dynamicSize(.03), vertical: dynamicSize(.02)),
            decoration: BoxDecoration(
              color: Color(int.parse(model.colorCode!)).withOpacity(.2),
              borderRadius: BorderRadius.all(Radius.circular(dynamicSize(.02))),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    if (model.discountAmount != null)
                      Text('\$ ${model.packagePrice!}',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: dynamicSize(.02),
                              decoration: TextDecoration.lineThrough)),
                    if (model.discountAmount != null)
                      Container(
                        margin: EdgeInsets.only(left: dynamicSize(.02)),
                        padding: EdgeInsets.symmetric(
                            horizontal: dynamicSize(.015),
                            vertical: dynamicSize(.005)),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(int.parse(model.colorCode!)),
                              width: 0.4),
                          borderRadius: BorderRadius.all(
                              Radius.circular(dynamicSize(.03))),
                        ),
                        child: Text('You save ${discountPercent.round()}%',
                            style: _textStyle.copyWith(
                                color: Colors.black,
                                fontSize: dynamicSize(.015))),
                      ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: dynamicSize(.015),
                          vertical: dynamicSize(.005)),
                      decoration: BoxDecoration(
                        color: Color(int.parse(model.colorCode!)),
                        borderRadius:
                            BorderRadius.all(Radius.circular(dynamicSize(.01))),
                      ),
                      child: Text('${model.packageName}',
                          style: _textStyle.copyWith(
                              color: Colors.white,
                              fontSize: dynamicSize(.015))),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$ $price',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: dynamicSize(.03),
                            fontWeight: FontWeight.bold)),
                    Text('${model.packageDuration} Months',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: dynamicSize(.03),
                            fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(
                  onPressed: () {
                    PackageController.pc.updateButtonOnTap(model);
                  },
                  child: const Text('Update')),
              SizedBox(height: dynamicSize(.02)),
              TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) =>
                            StatefulBuilder(builder: (context, setstate) {
                              return AlertDialog(
                                title: const Text('Delete this package?'),
                                actions: [
                                  PackageController.pc.loading.value
                                      ? const LoadingWidget()
                                      : TextButton(
                                          onPressed: () async {
                                            setstate(() {});
                                            await PackageController.pc
                                                .deletePackage(model.id!);
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'YES',
                                            style: TextStyle(
                                                color: Colors.redAccent),
                                          )),
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('NO'))
                                ],
                              );
                            }));
                  },
                  child: const Text('Delete',
                      style: TextStyle(color: Colors.redAccent)))
            ],
          ),
        )
      ],
    );
  }
}
