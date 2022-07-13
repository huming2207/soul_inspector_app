import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../common/characteristic_uuids.dart';
import '../common/setting_defs.dart';
import '../model/config_packet.dart';

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

  static Future<Uint8List> read(Uuid characteristicId, Uuid serviceId, String deviceId, [Duration timeout = const Duration(seconds: 10)]) async {
    final ble = FlutterReactiveBle();
    final characteristic = QualifiedCharacteristic(characteristicId: characteristicId, serviceId: serviceId, deviceId: deviceId);
    final completer = Completer<Uint8List>();
    final value = await ble.readCharacteristic(characteristic);
    completer.complete(Uint8List.fromList(value));
    return completer.future.timeout(timeout);
  }

  static Future<ConfigKeyPacket> writeBaudRate(int baud, String deviceId) async {
    final packet = ConfigNumPacket(opCode: ConfigPacketOpCode.u32, key: SettingKeys.baudRate, param: baud);
    final ackBytes = await BleHandler.writeAndGetNotify(CharacteristicUuids.configWrite, CharacteristicUuids.service, deviceId, packet.toBytes());
    return ConfigKeyPacket.fromBytes(ackBytes);
  }

  static Future<ConfigKeyPacket> writeStopBit(int stop, String deviceId) async {
    final packet = ConfigNumPacket(opCode: ConfigPacketOpCode.u32, key: SettingKeys.stopBits, param: stop);
    final ackBytes = await BleHandler.writeAndGetNotify(CharacteristicUuids.configWrite, CharacteristicUuids.service, deviceId, packet.toBytes());
    return ConfigKeyPacket.fromBytes(ackBytes);
  }

  static Future<ConfigKeyPacket> writeDataBits(int data, String deviceId) async {
    final packet = ConfigNumPacket(opCode: ConfigPacketOpCode.u32, key: SettingKeys.dataBits, param: data);
    final ackBytes = await BleHandler.writeAndGetNotify(CharacteristicUuids.configWrite, CharacteristicUuids.service, deviceId, packet.toBytes());
    return ConfigKeyPacket.fromBytes(ackBytes);
  }

  static Future<ConfigKeyPacket> writeParity(int parity, String deviceId) async {
    final packet = ConfigNumPacket(opCode: ConfigPacketOpCode.u32, key: SettingKeys.parityBits, param: parity);
    final ackBytes = await BleHandler.writeAndGetNotify(CharacteristicUuids.configWrite, CharacteristicUuids.service, deviceId, packet.toBytes());
    return ConfigKeyPacket.fromBytes(ackBytes);
  }
}