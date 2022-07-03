import 'dart:convert';
import 'dart:typed_data';

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

class ConfigNumPacket {
  late ConfigPacketOpCode opCode;
  late String key;
  late int param;

  ConfigNumPacket({required this.opCode, required this.key, required this.param});
  ConfigNumPacket.fromBytes(List<int> bytes) {
    final data = Uint8List.fromList(bytes);
    opCode = ConfigPacketOpCode.fromInt(data[0]);
    final keyBytes = data.sublist(1, 17);
    key = ascii.decode(keyBytes);
    param = ByteData.sublistView(data).getUint32(17, Endian.little);
  }
}

class ConfigKeyPacket {
  late ConfigPacketOpCode opCode;
  late String key;

  ConfigKeyPacket({required this.opCode, required this.key});
  ConfigKeyPacket.fromBytes(List<int> bytes) {
    final data = Uint8List.fromList(bytes);
    opCode = ConfigPacketOpCode.fromInt(data[0]);
    final keyBytes = data.sublist(1, 17);
    key = ascii.decode(keyBytes);
  }
}

class ConfigBlobPacket {
  late ConfigPacketOpCode opCode;
  late String key;
  late Uint8List param;

  ConfigBlobPacket({required this.opCode, required this.key, required this.param});
  ConfigBlobPacket.fromBytes(List<int> bytes) {
    final data = Uint8List.fromList(bytes);
    opCode = ConfigPacketOpCode.fromInt(data[0]);
    final keyBytes = data.sublist(1, 17);
    key = ascii.decode(keyBytes);
    param = data.sublist(19, data[18]);
  }
}