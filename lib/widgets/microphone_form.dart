import 'dart:async';

// import 'package:record/record.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AudioRecorder extends StatefulWidget {
  int itemId;

  AudioRecorder({super.key, required this.itemId});
  @override
  // ignore: library_private_types_in_public_api
  _AudioRecorderState createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  late Stopwatch _stopwatch;
  late Timer _timer;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          formatStopwatchTime(),
          style: const TextStyle(
            fontSize: 20,
            color: Colors.blue,
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                toggleRecording();
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isRecording ? Colors.red : Colors.blue,
                ),
                child: const Icon(
                  Icons.keyboard_voice,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                toggleRecording();
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF6163B1), Color(0xFF6F3D6D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // void startRecording() async {
  //   if (await Record.hasPermission()) {
  //     String path = '${(await getTemporaryDirectory()).path}/test.wav';
  //     await Record.start(path: path, encoder: AudioEncoder.AAC);
  //   } else {
  //     // Request permission to record audio
  //     Record.requestPermission();
  //   }
  // }

  // void stopRecording() async {
  //   await Record.stop();
  // }

  // void playRecordedAudio(String path) {
  //   AudioPlayer audioPlayer = AudioPlayer();
  //   audioPlayer.play(path, isLocal: true);
  // }

  void toggleRecording() {
    setState(() {
      if (_isRecording) {
        _stopwatch.stop();
        _timer.cancel();
      } else {
        _stopwatch.start();
        _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
          setState(() {});
        });
      }
      _isRecording = !_isRecording;
    });
  }

  String formatStopwatchTime() {
    final milliseconds = _stopwatch.elapsedMilliseconds;
    final seconds = (milliseconds / 1000).floor();
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;

    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
