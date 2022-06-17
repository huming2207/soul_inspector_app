import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:soul_inspector_app/controller/ble_search_controller.dart';
import 'package:soul_inspector_app/controller/main_controller.dart';
import 'package:soul_inspector_app/controller/setting_controller.dart';
import 'package:soul_inspector_app/views/ble_search.dart';
import 'package:soul_inspector_app/views/main_page.dart';
import 'package:soul_inspector_app/views/setting.dart';


void main() async {
  await GetStorage.init();
  runApp(SoulInspectorApp());
}

class SoulInspectorApp extends StatelessWidget {
  SoulInspectorApp({Key? key}) : super(key: key) {
    // TODO: binding somehow didn't work, so I leave a workaround here for now
    Get.put(MainController());
    Get.put(SettingController());
    Get.put(BleSearchController());
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Soul Inspector',
      theme: ThemeData(primarySwatch: Colors.green),
      home: MainPage(),
      getPages: [
        GetPage(name: '/main', page: () => MainPage(), binding: MainBinding()),
        GetPage(name: '/setting', page: () => const SettingPage(), binding: SettingBinding()),
        GetPage(name: '/bleSearch', page: () => BleSearchPage(), binding: BleSearchBinding())
      ],
    );
  }
}
