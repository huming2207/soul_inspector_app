import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:snack/snack.dart';
import 'package:soul_inspector_app/controller/setting_controller.dart';
import 'package:soul_inspector_app/views/ble_search.dart';

class SettingPage extends GetView<SettingController> {
  const SettingPage({Key? key}) : super(key: key);

  SettingsSection buildUartSection(BuildContext context, GetStorage box, int uartNumber) {
    return SettingsSection(
      title: Text('Serial Port $uartNumber'),
      tiles: <SettingsTile>[
        SettingsTile(
          title: const Text('Baud rate'),
          leading: const Icon(Icons.speed_outlined),
          description: const Text('UART speed'),
          onPressed: (BuildContext ctx) async {
            var result = await showTextInputDialog(
              context: ctx,
              textFields: [const DialogTextField(keyboardType: TextInputType.number)],
              title: 'Enter baud rate',
            );

            if (result == null || result.isEmpty) return;

            var val = int.tryParse(result.first);
            if (val == null || val < 0 || val > 6000000) {
              // ignore: use_build_context_synchronously
              const SnackBar(
                content: Text('Invalid baud rate!'),
                backgroundColor: Colors.red,
              ).show(ctx);
              return;
            }

            await box.write('UART_${uartNumber}_BAUD', val);
          },
        ),
        SettingsTile(
          title: const Text('Data bits'),
          leading: const Icon(Icons.straighten_outlined),
          description: const Text('Data bits per frame'),
          onPressed: (BuildContext ctx) async {
            var result = await showConfirmationDialog(context: ctx, title: 'Select data bit', actions: [
              const AlertDialogAction(key: 0, label: '5'),
              const AlertDialogAction(key: 1, label: '6'),
              const AlertDialogAction(key: 2, label: '7'),
              const AlertDialogAction(key: 3, label: '8'),
            ]);

            if (result == null) return;
            await box.write('UART_${uartNumber}_DATA', result);
          },
        ),
        SettingsTile(
          title: const Text('Parity bit'),
          leading: const Icon(Icons.rule_outlined),
          description: const Text('Parity modes'),
          onPressed: (BuildContext ctx) async {
            var result = await showConfirmationDialog(context: ctx, title: 'Select parity bit', actions: [
              const AlertDialogAction(key: 0, label: 'None'),
              const AlertDialogAction(key: 2, label: 'Even'),
              const AlertDialogAction(key: 3, label: 'Odd'),
            ]);

            if (result == null) return;
            await box.write('UART_${uartNumber}_PARITY', result);
          },
        ),
        SettingsTile(
          title: const Text('Stop bit'),
          leading: const Icon(Icons.stop_circle_outlined),
          description: const Text('Stop bit modes'),
          onPressed: (BuildContext ctx) async {
            var result = await showConfirmationDialog(context: ctx, title: 'Select stop bits', actions: [
              const AlertDialogAction(key: 1, label: '1.0 bit'),
              const AlertDialogAction(key: 2, label: '1.5 bit'),
              const AlertDialogAction(key: 3, label: '2 bits'),
            ]);

            if (result == null) return;
            await box.write('UART_${uartNumber}_STOP', result);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: SettingsList(
          sections: [
            SettingsSection(
              title: const Text('Soul Inspector Device'),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  title: const Text('Device connection'),
                  leading: const Icon(Icons.phonelink_ring_outlined),
                  description: const Text('Connect your Soul Inspector via BLE'),
                  onPressed: (BuildContext ctx) {
                    Get.to(() => BleSearchPage());
                  },
                ),
              ],
            ),
            buildUartSection(context, box, 1),
            buildUartSection(context, box, 2),
          ],
        ));
  }
}
