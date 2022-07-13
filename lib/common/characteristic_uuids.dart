import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class CharacteristicUuids {
  static final service = Uuid.parse('6ae00001-efc9-11ec-8ea0-0242ac120002');
  static final configRead = Uuid.parse('6ae00002-efc9-11ec-8ea0-0242ac120002');
  static final configWrite = Uuid.parse('6ae00003-efc9-11ec-8ea0-0242ac120002');
  static final uartRx = Uuid.parse('6ae00004-efc9-11ec-8ea0-0242ac120002');
  static final uartTx = Uuid.parse('6ae00005-efc9-11ec-8ea0-0242ac120002');
  static final timeSync = Uuid.parse('6ae00006-efc9-11ec-8ea0-0242ac120002');
  static final devInfo = Uuid.parse('6ae00007-efc9-11ec-8ea0-0242ac120002');
}