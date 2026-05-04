// import 'package:flutter/material.dart';
// import 'dart:isolate';
//
//
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: WithIsolatePage(),
//     );
//   }
// }
//
// class WithIsolatePage extends StatefulWidget {
//   const WithIsolatePage({super.key});
//
//   @override
//   State<WithIsolatePage> createState() => _WithIsolatePageState();
// }
//
// class _WithIsolatePageState extends State<WithIsolatePage> {
//   bool loading = false;
//   int result = 0;
//
//   Future<void> runIsolate() async {
//     setState(() => loading = true);
//
//     final receivePort = ReceivePort();
//
//     await Isolate.spawn(heavyTaskIsolate, receivePort.sendPort);
//
//     result = await receivePort.first;
//
//     setState(() => loading = false);
//   }
//
//   static void heavyTaskIsolate(SendPort sendPort) {
//     List<int> numbers = List.generate(5000000, (i) => i);
//
//     List<String> strings = numbers.map((e) => e.toString()).toList();
//
//     List<int> backToInt = strings.map((e) => int.parse(e)).toList();
//
//     int sum = backToInt.reduce((a, b) => a + b);
//
//     sendPort.send(sum);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("With Isolate")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (loading) const CircularProgressIndicator(),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: runIsolate,
//               child: const Text("Run Task"),
//             ),
//             const SizedBox(height: 20),
//             Text("Result: $result"),
//           ],
//         ),
//       ),
//     );
//   }
// }