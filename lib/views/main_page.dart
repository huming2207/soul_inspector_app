import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_inspector_app/controller/ble_controller.dart';
import 'package:soul_inspector_app/controller/main_controller.dart';
import 'package:soul_inspector_app/views/ble_search.dart';
import 'package:soul_inspector_app/views/setting.dart';
import 'package:xterm/frontend/terminal_view.dart';
import 'package:xterm/terminal/terminal.dart';

import '../protocol/ble_console_backend.dart';

class MainPage extends GetView<MainController> {
  MainPage({Key? key}) : super(key: key);
  final bleController = Get.find<BleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Soul Inspector'),
          actions: <Widget>[
            IconButton(icon: const Icon(Icons.tune_outlined), tooltip: 'Option menu', onPressed: () => Get.to(() => SettingPage())),
            Obx(() => IconButton(
                onPressed: () => Get.to(() => BleSearchPage()),
                icon: bleController.selectedDeviceId.isEmpty ? const Icon(Icons.bluetooth_disabled) : const Icon(Icons.bluetooth_audio),
                tooltip: 'Device connection')
            ),
          ],
        ),
        body: TerminalView(terminal: Terminal(maxLines: 10000, backend: BleConsoleBackend())));
  }
}
