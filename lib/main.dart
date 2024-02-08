import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Arduino RC Car'),
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

  @override
  void initState() {
    super.initState();
    _adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.bluetooth),
            onPressed: () {
              /// TODO: implement bluetooth device lists
            },
          ),
        ],
      ),
      body: Center(
        child: Row(
          children: [
            const Flexible(
              flex: 4,
              child: ControlPad(),
            ),
            const Spacer(),
            Flexible(
              flex: 4,
              child: Container(
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ControlPad extends StatelessWidget {
  const ControlPad({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ControlPadBtn(
          icon: Icons.arrow_upward_outlined,
          onTap: () {
            print("FORWARD");
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ControlPadBtn(
              icon: Icons.arrow_back_outlined,
              onTap: () {
                print("LEFT");
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
                print("RIGHT");
              },
            ),
          ],
        ),
        ControlPadBtn(
          icon: Icons.arrow_downward_outlined,
          onTap: () {
            print("REVERSE");
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


/*
Class called RemoteControllerService
 - functions such as forward, backward, left, right (send data to arduino via bluetooth) 
 - should not know about the bluetooth implementation
 - we should inject an abstracted class that is a bluetooth implementation

Abstracted class called BluetoothService
 - 

*/