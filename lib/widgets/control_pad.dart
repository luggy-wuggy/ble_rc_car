import 'dart:convert';

import 'package:ble_rc_car/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ControlPad extends StatelessWidget {
  const ControlPad({super.key, required this.characteristic});

  final BluetoothCharacteristic? characteristic;

  sendCommandToRC(String command) async {
    if (characteristic == null) {
      Snackbar.show(ABC.c, prettyException("Write Error:", Error()), success: false);
    }

    try {
      List<int> data = utf8.encode(command);
      await characteristic?.write(data);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Write Error:", e), success: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ControlPadBtn(
          icon: Icons.arrow_upward_outlined,
          onTap: () {
            // print("FORWARD");
            sendCommandToRC("%F#");
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ControlPadBtn(
              icon: Icons.arrow_back_outlined,
              onTap: () {
                sendCommandToRC("%L#");
              },
            ),
            Container(
              height: 60,
              width: 60,
              color: Colors.black,
            ),
            ControlPadBtn(
              icon: Icons.arrow_forward_ios_outlined,
              onTap: () {
                sendCommandToRC("%R#");
              },
            ),
          ],
        ),
        ControlPadBtn(
          icon: Icons.arrow_downward_outlined,
          onTap: () {
            sendCommandToRC("%B#");
          },
        ),
      ],
    );
  }
}

class ControlPadBtn extends StatelessWidget {
  const ControlPadBtn({super.key, this.icon, this.onTap});

  final IconData? icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: 60,
        decoration: const BoxDecoration(color: Colors.black),
        child: Icon(
          icon,
          size: 24,
          color: Colors.white,
        ),
      ),
    );
  }
}
