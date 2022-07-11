import 'dart:convert';
import 'dart:typed_data';

class DevInfoPacket {
  Uint8List macAddr = Uint8List(6);
  Uint8List flashId = Uint8List(8);
  String sdkVer = '';
  String devModel = '';
  String devFirmwareVer = '';

  DevInfoPacket.dummy();

  DevInfoPacket(Uint8List bytes) {
    macAddr = bytes.sublist(0, 6);
    flashId = bytes.sublist(6, 14);
    sdkVer = ascii.decode(bytes.sublist(14, 46));
    devModel = ascii.decode(bytes.sublist(46, 78));
    devFirmwareVer = ascii.decode(bytes.sublist(78, 110));
  }
}