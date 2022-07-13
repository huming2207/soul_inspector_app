import 'dart:convert';
import 'dart:typed_data';

import 'package:soul_inspector_app/protocol/protocol_exceptions.dart';

enum ConfigPacketOpCode {
  u32(0),
  i32Pos(1),
  i32Neg(2),
  string(3),
  blob(4),
  delete(0xa0),
  nuke(0xa1),
  ok(0xf0),
  errorNotFound(0xf1),
  errorInvalidSize(0xf2),
  errorUnknownType(0xf3),
  errorGeneric(0xff);

  static ConfigPacketOpCode fromInt(int value) {
    switch (value) {
      case 0:
        return ConfigPacketOpCode.u32;
      case 1:
        return ConfigPacketOpCode.i32Pos;
      case 2:
        return ConfigPacketOpCode.i32Neg;
      case 3:
        return ConfigPacketOpCode.string;
      case 4:
        return ConfigPacketOpCode.blob;
      case 0xa0:
        return ConfigPacketOpCode.delete;
      case 0xa1:
        return ConfigPacketOpCode.nuke;
      case 0xf0:
        return ConfigPacketOpCode.ok;
      case 0xf1:
        return ConfigPacketOpCode.errorNotFound;
      case 0xf2:
        return ConfigPacketOpCode.errorInvalidSize;
      case 0xf3:
        return ConfigPacketOpCode.errorUnknownType;
      default:
        return ConfigPacketOpCode.errorGeneric;
    }
  }

  const ConfigPacketOpCode(this.value);
  final int value;
}

abstract class ConfigPacket {
  late ConfigPacketOpCode opCode;
  late String key;

  Uint8List toBytes();
  static Uint8List uint32ToLEBytes(int value) =>
      Uint8List(4)..buffer.asByteData().setUint32(0, value, Endian.little);

  static Uint8List stringToPaddedList(String str, int byteCount) {
    final asciiBytes = ascii.encode(str);
    final bytes = BytesBuilder();
    if (asciiBytes.length >= byteCount) {
      bytes.add(asciiBytes.sublist(0, byteCount - 1));
      bytes.addByte(0);
    } else {
      bytes.add(asciiBytes);
      bytes.add(Uint8List(byteCount - asciiBytes.length - 1));
      bytes.addByte(0); // Make the last item is '\0'
    }

    return bytes.toBytes();
  }
}

class ConfigNumPacket implements ConfigPacket {
  @override
  late ConfigPacketOpCode opCode;

  @override
  late String key;
  late int param;

  ConfigNumPacket({required this.opCode, required this.key, required this.param}) {
    param = param.abs();
  }

  ConfigNumPacket.fromBytes(List<int> bytes) {
    if (bytes.length < 21) {
      throw InvalidPacketLengthException('Length too short: ${bytes.length}');
    }

    final data = Uint8List.fromList(bytes);
    opCode = ConfigPacketOpCode.fromInt(data[0]);
    final keyBytes = data.sublist(1, 17);
    key = ascii.decode(keyBytes);
    param = ByteData.sublistView(data).getUint32(17, Endian.little);
  }

  @override
  Uint8List toBytes() {
    final bytes = BytesBuilder();
    bytes.addByte(opCode.value & 0xff);
    bytes.add(ConfigPacket.stringToPaddedList(key, 16));
    bytes.add(ConfigPacket.uint32ToLEBytes(param.abs()));

    return bytes.toBytes();
  }
}

class ConfigKeyPacket implements ConfigPacket {
  @override
  late ConfigPacketOpCode opCode;

  @override
  late String key;

  ConfigKeyPacket({required this.opCode, required this.key});
  ConfigKeyPacket.fromBytes(List<int> bytes) {
    if (bytes.length < 17) {
      throw InvalidPacketLengthException('Length too short: ${bytes.length}');
    }

    final data = Uint8List.fromList(bytes);
    opCode = ConfigPacketOpCode.fromInt(data[0]);
    final keyBytes = data.sublist(1, 17);
    key = ascii.decode(keyBytes);
  }

  @override
  Uint8List toBytes() {
    final bytes = BytesBuilder();
    bytes.addByte(opCode.value & 0xff);
    bytes.add(ConfigPacket.stringToPaddedList(key, 16));

    return bytes.toBytes();
  }
}

class ConfigBlobPacket implements ConfigPacket {
  @override
  late ConfigPacketOpCode opCode;

  @override
  late String key;
  late Uint8List param;

  ConfigBlobPacket({required this.opCode, required this.key, required this.param});
  ConfigBlobPacket.fromBytes(List<int> bytes) {
    if (bytes.length < 17) {
      throw InvalidPacketLengthException('Length too short: ${bytes.length}');
    }

    final data = Uint8List.fromList(bytes);
    opCode = ConfigPacketOpCode.fromInt(data[0]);
    final keyBytes = data.sublist(1, 17);
    key = ascii.decode(keyBytes);
    param = data.sublist(19, data[18]);
  }

  @override
  Uint8List toBytes() {
    final bytes = BytesBuilder();
    bytes.addByte(opCode.value & 0xff);
    bytes.add(ascii.encode(key.substring(0, 16)));
    bytes.add(param);

    return bytes.toBytes();
  }
}