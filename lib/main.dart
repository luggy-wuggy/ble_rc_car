import 'dart:async';

import 'package:ble_rc_car/screens/scan_screen.dart';
import 'package:ble_rc_car/utils/navigator.dart';
import 'package:ble_rc_car/widgets/control_pad.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'screens/bluetooth_off_screen.dart';

void main() async {
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  runApp(const FlutterBlueApp());
}

//
// This widget shows BluetoothOffScreen or
// ScanScreen depending on the adapter state
//
class FlutterBlueApp extends StatefulWidget {
  const FlutterBlueApp({Key? key}) : super(key: key);

  @override
  State<FlutterBlueApp> createState() => _FlutterBlueAppState();
}

class _FlutterBlueAppState extends State<FlutterBlueApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.lightBlue,
      home: const MyHomePage(title: 'Arduino RC Car'),
      navigatorObservers: [BluetoothAdapterStateObserver()],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;
  late StreamSubscription<OnConnectionStateChangedEvent> _connectionStateSubscription;
  BluetoothCharacteristic? characteristic;
  BluetoothDevice? _rcDevice;

  @override
  void initState() {
    super.initState();
    _adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      if (mounted) {
        setState(() {});
      }
    });

    _connectionStateSubscription = FlutterBluePlus.events.onConnectionStateChanged
        .where((event) => event.device.platformName == "HC-06")
        .listen((event) {
      setState(() {
        _rcDevice = event.device;
        // characteristic = _rcDevice?.servicesList
        //     .firstWhere((element) => element.uuid.str == "ffe0")
        //     .characteristics
        //     .firstWhere((element) => element.characteristicUuid.str == "ffe2");
      });
      print("HC-06 CHANGED: ${event.device.servicesList}");
    });
  }

  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();
    _connectionStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.bluetooth),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ScanScreen(),
                      settings: const RouteSettings(name: '/ScanScreen'),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: Row(
              children: [
                Flexible(
                  flex: 4,
                  child: ControlPad(characteristic: characteristic),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text("STATUS: ${_rcDevice?.isConnected ?? false ? "connected" : "disconnected"}"),
                ),
                Flexible(
                  flex: 4,
                  child: Container(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_adapterState != BluetoothAdapterState.on) const BluetoothOffOverlay()
      ],
    );
  }
}



/*
Class called RemoteControllerService
 - functions such as forward, backward, left, right (send data to arduino via bluetooth) 
 - should not know about the bluetooth implementation
 - we should inject an abstracted class that is a bluetooth implementation

Abstracted class called BluetoothService
 - 

*/