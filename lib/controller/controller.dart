import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Controller extends GetxController{
  static final Controller instance = Get.find();
  RxBool loading=false.obs;

  @override
  onInit(){
    super.onInit();
    initApp();
  }
  Future<void> initApp() async {}

  void setData(String key, dynamic value) async=>await GetStorage().write(key, value);
  int? getInt(String key) => GetStorage().read(key);
  String? getString(String key) => GetStorage().read(key);
  bool? getBool(String key) => GetStorage().read(key);
  double? getDouble(String key) => GetStorage().read(key);
  dynamic getData(String key) => GetStorage().read(key);
  void clearData() async => await GetStorage().erase();


}