import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:soul_inspector_app/common/characteristic_uuids.dart';

class BleController extends GetxController {
  final String title = 'Device Search & Selection';
  final ble = FlutterReactiveBle();
  var devices = <DiscoveredDevice>[].obs;
  var selectedDeviceId = ''.obs;
  var selectedDeviceName = ''.obs;
  var selectedDeviceMtu = 20.obs;
  var hasError = false.obs;
  var connectState = DeviceConnectionState.disconnected.obs;

  void addDevice(DiscoveredDevice device) {
    final deviceList = devices.toList(growable: true);
    if (deviceList.isNotEmpty) {
      deviceList.addAll(devices.where((a) => deviceList.every((b) => a.id != b.id)));
    } else {
      deviceList.add(device);
    }

    devices.value = deviceList;
    update(devices);
  }

  void clearDevice() {
    devices.value = [];
    update(devices);
  }


  void setSelectedDevice(DiscoveredDevice device) {
    ble.connectToAdvertisingDevice(
        id: device.id,
        withServices: [CharacteristicUuids.service],
        prescanDuration: const Duration(seconds: 5)
    ).listen((event) async {
      connectState.value = event.connectionState;
      if (event.connectionState == DeviceConnectionState.connected) {
        selectedDeviceMtu.value = await ble.requestMtu(deviceId: device.id, mtu: 260);
        await ble.requestConnectionPriority(deviceId: device.id, priority: ConnectionPriority.highPerformance);
      }
    }, onError: (dynamic error) {
      Fluttertoast.showToast(msg: 'Error on Bluetooth connection: $error', toastLength: Toast.LENGTH_LONG);
    });

    selectedDeviceId.value = device.id;
    selectedDeviceName.value = device.name;
  }
}

class BleSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BleController());
  }

}