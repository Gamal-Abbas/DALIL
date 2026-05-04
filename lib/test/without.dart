import 'package:flutter/material.dart';
import 'dart:isolate';

class ComparePage extends StatefulWidget {
  const ComparePage({super.key});

  @override
  State<ComparePage> createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage>
    with SingleTickerProviderStateMixin {
  int withoutTime = 0;
  int withTime = 0;

  int result = 0;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();


    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -25, end: 25).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  Future<void> runWithoutIsolate() async {
    final stopwatch = Stopwatch()..start();

    List<int> numbers = List.generate(1000000, (i) => i);

    List<String> strings = numbers.map((e) => e.toString()).toList();

    List<int> backToInt = strings.map((e) => int.parse(e)).toList();

    result = backToInt.reduce((a, b) => a + b);

    stopwatch.stop();

    setState(() {
      withoutTime = stopwatch.elapsedMilliseconds;
    });
  }


  Future<void> runWithIsolate() async {
    final stopwatch = Stopwatch()..start();

    final receivePort = ReceivePort();

    await Isolate.spawn(_heavyTask, receivePort.sendPort);

    result = await receivePort.first;

    stopwatch.stop();

    setState(() {
      withTime = stopwatch.elapsedMilliseconds;
    });
  }

  static void _heavyTask(SendPort sendPort) {
    List<int> numbers = List.generate(1000000, (i) => i);

    List<String> strings = numbers.map((e) => e.toString()).toList();

    List<int> backToInt = strings.map((e) => int.parse(e)).toList();

    int sum = backToInt.reduce((a, b) => a + b);

    sendPort.send(sum);
  }

  Widget movingDot(double offset) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_animation.value + offset, 0),
          child: child,
        );
      },
      child: const CircleAvatar(
        radius: 8,
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true
          ,title: const Text("Isolate vs Without Isolate\n with Ziad 🫡 ")),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              movingDot(0),
              const SizedBox(width: 10),
              movingDot(10),
              const SizedBox(width: 10),
              movingDot(20),
            ],
          ),

          const SizedBox(height: 40),

          ElevatedButton(
            onPressed: runWithoutIsolate,
            child: const Text("Run WITHOUT Isolate ❌"),
          ),



          const SizedBox(height: 25),

          ElevatedButton(
            onPressed: runWithIsolate,
            child: const Text("Run WITH Isolate ✅"),
          ),



          const SizedBox(height: 30),


        ],
      ),
    );
  }
}