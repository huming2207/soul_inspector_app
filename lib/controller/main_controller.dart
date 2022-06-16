import 'package:get/get.dart';

class MainController extends GetxController {
  static MainController get to => Get.find();
}

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());
  }
}
