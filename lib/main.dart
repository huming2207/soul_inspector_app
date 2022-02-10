import 'package:flutter/material.dart';
import 'dart:math';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:soul_inspector_app/ble_console_backend.dart';
import 'package:soul_inspector_app/setting_page.dart';
import 'package:xterm/flutter.dart';
import 'package:xterm/terminal/terminal.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Soul Inspector',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomePage(),
    );
  }
}

// Home Screen
class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final terminal = Terminal(maxLines: 10000, backend: BleConsoleBackend());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soul Inspector'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.tune_outlined),
            tooltip: 'Option menu',
            onPressed: () {
              Get.to(const SettingPage(), arguments: {
                'id': Random().nextInt(1000).toString()
              });
            },
          ),
        ],
      ),
      body: TerminalView(terminal: terminal)
    );
  }
}

