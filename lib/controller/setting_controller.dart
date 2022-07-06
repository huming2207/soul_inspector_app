import 'package:get/get.dart';
import 'package:soul_inspector_app/common/characteristic_uuids.dart';
import 'package:soul_inspector_app/common/setting_defs.dart';
import 'package:soul_inspector_app/protocol/ble_handler.dart';
import 'package:soul_inspector_app/protocol/config_packet.dart';

class SettingController extends GetxController {
  Future<ConfigKeyPacket> writeBaudRate(int baud, String deviceId) async {
    final packet = ConfigNumPacket(opCode: ConfigPacketOpCode.u32, key: SettingKeys.baudRate, param: baud);
    final ackBytes = await BleHandler.writeAndGetNotify(CharacteristicUuids.service, CharacteristicUuids.configWrite, deviceId, packet.toBytes());
    return ConfigKeyPacket.fromBytes(ackBytes);
  }

  Future<ConfigKeyPacket> writeStopBit(int baud, String deviceId) async {
    final packet = ConfigNumPacket(opCode: ConfigPacketOpCode.u32, key: SettingKeys.stopBits, param: baud);
    final ackBytes = await BleHandler.writeAndGetNotify(CharacteristicUuids.service, CharacteristicUuids.configWrite, deviceId, packet.toBytes());
    return ConfigKeyPacket.fromBytes(ackBytes);
  }

  Future<ConfigKeyPacket> writeDataBits(int baud, String deviceId) async {
    final packet = ConfigNumPacket(opCode: ConfigPacketOpCode.u32, key: SettingKeys.dataBits, param: baud);
    final ackBytes = await BleHandler.writeAndGetNotify(CharacteristicUuids.service, CharacteristicUuids.configWrite, deviceId, packet.toBytes());
    return ConfigKeyPacket.fromBytes(ackBytes);
  }

  Future<ConfigKeyPacket> writeParity(int baud, String deviceId) async {
    final packet = ConfigNumPacket(opCode: ConfigPacketOpCode.u32, key: SettingKeys.parityBits, param: baud);
    final ackBytes = await BleHandler.writeAndGetNotify(CharacteristicUuids.service, CharacteristicUuids.configWrite, deviceId, packet.toBytes());
    return ConfigKeyPacket.fromBytes(ackBytes);
  }
}

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingController());
  }
}