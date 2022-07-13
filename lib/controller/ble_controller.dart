import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:soul_inspector_app/common/characteristic_uuids.dart';
import 'package:soul_inspector_app/views/main_page.dart';

import '../model/dev_info_packet.dart';
import '../protocol/ble_handler.dart';

class BleController extends GetxController {
  final String title = 'Device Search & Selection';
  final ble = FlutterReactiveBle();
  var devices = <DiscoveredDevice>[].obs;
  var selectedDeviceId = ''.obs;
  var selectedDeviceName = ''.obs;
  var selectedDeviceMtu = 20.obs;
  var hasError = false.obs;
  var connectState = DeviceConnectionState.disconnected.obs;
  var devInfo = DevInfoPacket.dummy().obs;

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
        devInfo.value = DevInfoPacket(await BleHandler.read(CharacteristicUuids.devInfo, CharacteristicUuids.service, device.id));
        selectedDeviceId.value = device.id;
        selectedDeviceName.value = device.name;

        Fluttertoast.showToast(msg: 'Connected to ${hex.encode(devInfo.value.macAddr)}; FW ${devInfo.value.devFirmwareVer}');
        Get.to(() => MainPage());
      }
    }, onError: (dynamic error) {
      Fluttertoast.showToast(msg: 'Error on Bluetooth connection: $error', toastLength: Toast.LENGTH_LONG);
    });
  }

  Future<int> setTime() async {
    final ts = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final value = [(ts & 0xff), (ts >> 8) & 0xff, (ts >> 16) & 0xff, (ts >> 24) & 0xff];
    final result = await BleHandler.writeAndGetNotify(
        CharacteristicUuids.timeSync,
        CharacteristicUuids.service,
        selectedDeviceId.value,
        Uint8List.fromList(value)
    );

    return ByteData.sublistView(Uint8List.fromList(result)).getUint64(0, Endian.little);
  }
}

class BleSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BleController());
  }
}