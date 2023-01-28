import 'package:cricland_admin/constants/dynamic_size.dart';
import 'package:cricland_admin/constants/static_string.dart';
import 'package:cricland_admin/repository/package/controller/package_controller.dart';
import 'package:cricland_admin/widgets/loading_widget.dart';
import 'package:cricland_admin/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

class UpdatePackage extends StatelessWidget {
  const UpdatePackage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PackageController>(builder: (controller) {
      return Obx(() => SingleChildScrollView(
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
                        textInputType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                    ),
                    SizedBox(width: dynamicSize(0.03)),

                    ///Discount Price
                    Expanded(
                      child: TextFieldWidget(
                        controller: controller.discountAmount,
                        labelText: StaticString.discountAmount,
                        textInputType: const TextInputType.numberWithOptions(
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
                  textInputType:
                      const TextInputType.numberWithOptions(decimal: true),
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Text(controller.pickerColorCode.toString()),
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
                              await controller.updatePackage();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Update Package",
                                  style: TextStyle(fontSize: dynamicSize(.02))),
                            )),
                      )
              ],
            ),
          ));
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
