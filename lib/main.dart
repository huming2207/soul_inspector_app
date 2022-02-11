import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:soul_inspector_app/views/home.dart';


void main() async {
  await GetStorage.init();
  runApp(const SoulInspectorApp());
}

class SoulInspectorApp extends StatelessWidget {
  const SoulInspectorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Soul Inspector',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomePage(),
    );
  }
}
