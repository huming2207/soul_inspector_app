import 'package:get/get.dart';

class SettingController extends GetxController {

}

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingController());
  }
}