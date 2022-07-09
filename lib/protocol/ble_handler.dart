import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get_storage/get_storage.dart';

class BleHandler {
  static Future<Uint8List> writeAndGetNotify(Uuid characteristicId, Uuid serviceId, String deviceId, Uint8List value, [Duration timeout = const Duration(seconds: 10)]) async {
    final ble = FlutterReactiveBle();
    final characteristic = QualifiedCharacteristic(characteristicId: characteristicId, serviceId: serviceId, deviceId: deviceId);
    await ble.writeCharacteristicWithResponse(characteristic, value: value);

    final completer = Completer<Uint8List>();
    final sub = ble.subscribeToCharacteristic(characteristic).listen(null);
    sub.onData((data) async {
      await sub.cancel();
      completer.complete(Uint8List.fromList(data));
    });

    return completer.future.timeout(timeout);
  }

  static Future<Uint8List> read(Uuid characteristicId, Uuid serviceId, String deviceId, Uint8List value, [Duration timeout = const Duration(seconds: 10)]) async {
    final ble = FlutterReactiveBle();
    final characteristic = QualifiedCharacteristic(characteristicId: characteristicId, serviceId: serviceId, deviceId: deviceId);
    final completer = Completer<Uint8List>();
    final value = await ble.readCharacteristic(characteristic);
    completer.complete(Uint8List.fromList(value));
    return completer.future.timeout(timeout);
  }
}