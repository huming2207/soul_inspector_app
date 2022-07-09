import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleHandler {
  static Future<List<int>> writeAndGetNotify(Uuid characteristicId, Uuid serviceId, String deviceId, Uint8List value, [Duration timeout = const Duration(seconds: 5)]) async {
    final ble = FlutterReactiveBle();
    final characteristic = QualifiedCharacteristic(characteristicId: characteristicId, serviceId: serviceId, deviceId: deviceId);
    await ble.writeCharacteristicWithResponse(characteristic, value: value);

    final completer = Completer<List<int>>();
    final sub = ble.subscribeToCharacteristic(characteristic).listen(null);
    sub.onData((data) async {
      await sub.cancel();
      completer.complete(data);
    });

    return completer.future.timeout(timeout);
  }
}