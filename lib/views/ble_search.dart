import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:soul_inspector_app/common/characteristic_uuids.dart';
import 'package:soul_inspector_app/controller/ble_search_controller.dart';
import 'package:soul_inspector_app/controller/main_controller.dart';

class BleSearchPage extends GetView<BleSearchController> {
  final flutterReactiveBle = FlutterReactiveBle();
  final errorSnackBar = const SnackBar(content: Text('Failed to scan device!'), backgroundColor: Colors.red);
  final mainController = Get.find<MainController>();

  BleSearchPage({Key? key}) : super(key: key) {
    flutterReactiveBle.scanForDevices(withServices: [CharacteristicUuids.service], scanMode: ScanMode.balanced).listen((device) {
      print('Got device: $device');
      controller.addDevice(device);
    }).onError((error) {
      print('Got error: $error');
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
                    return Card(
                        child: ListTile(
                            title: Text(device.name),
                            subtitle: Text('ID: ${device.id}; RSSI: ${device.rssi}'),
                            onTap: () async {
                              controller.setSelectedDevice(device);
                              mainController.selectedDeviceId.value = device.id;

                              await flutterReactiveBle.requestConnectionPriority(deviceId: device.id, priority: ConnectionPriority.highPerformance);
                              final timeSyncCharacteristic = QualifiedCharacteristic(characteristicId: CharacteristicUuids.timeSync, serviceId: CharacteristicUuids.service, deviceId: device.id);

                              final ts = DateTime.now().millisecondsSinceEpoch ~/ 1000;
                              final value = [(ts & 0xff), (ts >> 8) & 0xff, (ts >> 16) & 0xff, (ts >> 24) & 0xff];
                              await flutterReactiveBle.writeCharacteristicWithResponse(timeSyncCharacteristic, value: value);
                            }));
                  })
              ],
            )),
      ),
    );
  }
}
