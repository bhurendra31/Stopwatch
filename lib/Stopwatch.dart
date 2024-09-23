import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  int myIndex = 0;
  Timer? _timer;  // Timer is nullable now to handle initialization checks
  int _start = 0;
  bool _isRunning = false;
  List laps = [];

  @override
  void initState() {
    super.initState();
  }

  void _startTimer() {
    if (!_isRunning) {
      _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        setState(() {
          _start++;
        });
      });
      setState(() {
        _isRunning = true;
      });
    }
  }

  void _stoptimer() {
    if (_isRunning && _timer != null) {
      _timer?.cancel();
      setState(() {
        _isRunning = false;
      });
    }
  }

  void _resettimer() {
    _stoptimer();
    setState(() {
      _start = 0;
      laps.clear();
    });
  }

  void _recordLap() {
    String lap = _formatTime(_start);
    setState(() {
      laps.insert(0, lap);
    });
  }

  @override
  void dispose() {
    // Ensure timer is properly canceled if it was initialized
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int milliseconds) {
    final minutes = (milliseconds ~/ 6000).toString().padLeft(2, '0');
    final seconds = ((milliseconds % 6000) ~/ 100).toString().padLeft(2, '0');
    final microseconds = (milliseconds % 100).toString().padLeft(2, '0');
    return '$minutes:$seconds:$microseconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Stopwatch',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            Icon(
              Icons.watch,
              color: Colors.white,
            )
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 110),
            Text(
              _formatTime(_start),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 65,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 80),
            
            // Dynamic Button Layout
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (_isRunning)
                  ElevatedButton(
                    onPressed: _stoptimer,
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(30)),
                    child: const Text('Stop'),
                  )
                else
                  ElevatedButton(
                    onPressed: _startTimer,
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(30)),
                    child: const Text('Start'),
                  ),

                if (_isRunning)
                  ElevatedButton(
                    onPressed: _recordLap,
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(30)),
                    child: const Text('Lap'),
                  )
                else
                  ElevatedButton(
                    onPressed: _resettimer,
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromARGB(255, 181, 136, 13),
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(30)),
                    child: const Text('Reset'),
                  ),
              ],
            ),
            
            const SizedBox(height: 90),
            SizedBox(
              height: 150,
              child: ListView.builder(
                itemCount: laps.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      children: [
                        Text(
                          (index + 1).toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 30),
                        Text(
                          laps[index],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}