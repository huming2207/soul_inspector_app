import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:soul_inspector_app/controller/ble_search_controller.dart';
import 'package:soul_inspector_app/controller/main_controller.dart';

class BleSearchPage extends GetView<BleSearchController> {
  final flutterReactiveBle = FlutterReactiveBle();
  final errorSnackBar = const SnackBar(content: Text('Failed to scan device!'), backgroundColor: Colors.red);
  var mainController = Get.find<MainController>();

  BleSearchPage({Key? key}) : super(key: key) {
    flutterReactiveBle.scanForDevices(withServices: [Uuid.parse('ab565e22-3d1a-47ed-9ff9-6ea0f7563101')], scanMode: ScanMode.lowLatency).listen((device) {
      controller.addDevice(device);
    }).onError((error) {
      controller.hasError.value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.title),
      ),
      body: Scrollbar(
        child: Obx(() => ListView(
              children: [
                for (final device in controller.devices)
                  Builder(builder: (context) {
                    return Card(child: ListTile(title: Text(device.name), subtitle: Text('ID: ${device.id}; RSSI: ${device.rssi}'), onTap: () {
                      controller.setSelectedDevice(device);
                    }));
                  })
              ],
            )),
      ),
    );
  }
}
