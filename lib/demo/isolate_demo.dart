import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/material.dart';

class IsolateDemo extends StatefulWidget {
  const IsolateDemo({super.key});

  @override
  State<IsolateDemo> createState() {
    return _IsolateStateDemo();
  }
}

class _IsolateStateDemo extends State<IsolateDemo> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text(
          "Isolation Demo App",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (isLoading)
              ? Center(child: CircularProgressIndicator())
              : const Text("Loding Data"),
          SizedBox(height: 60),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                int sum = 0;

                for (int i = 0; i < 1000000000; i++) {
                  sum += i;
                }

                log("Without Isolate : $sum");
              },
              child: const Text("Task 1 without Isolation"),
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () async {
                ReceivePort receivePort = ReceivePort();

                await Isolate.spawn(heavyCalculation, receivePort.sendPort);

                receivePort.listen((data) {
                  log("with isolation : $data");

                  receivePort.close();
                });
              },
              child: const Text("Task 2 with Isolation"),
            ),
          ),
        ],
      ),
    );
  }
}

void heavyCalculation(SendPort sendPort) {
  int sum = 0;

  for (int i = 0; i < 1000000000; i++) {
    sum += i;
  }

  sendPort.send(sum);
}
