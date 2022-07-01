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
  late int data;

  ConfigNumPacket({required this.opCode, required this.key, required this.data});
  ConfigNumPacket.fromBytes(List<int> bytes) {
    opCode = ConfigPacketOpCode.fromInt(bytes[0]);
  }
}