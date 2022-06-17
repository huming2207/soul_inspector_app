import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';

class BleSearchController extends GetxController {
  final String title = 'Device Search & Selection';
  var devices = <DiscoveredDevice>[].obs;
  var selectedDeviceId = ''.obs;
  var selectedDeviceName = ''.obs;
  var hasError = false.obs;

  void addDevice(DiscoveredDevice device) {
    final deviceList = devices.toList(growable: true);
    deviceList.add(device);
    devices.value = deviceList;
    update(devices);
  }

  void setSelectedDevice(DiscoveredDevice device) {
    selectedDeviceId.value = device.id;
    selectedDeviceName.value = device.name;
  }
}

class BleSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BleSearchController());
  }

}