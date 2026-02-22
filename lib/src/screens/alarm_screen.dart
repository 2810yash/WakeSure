import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:wake_sure/src/notifications/notification_helper.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final SpeechToText _speechToText = SpeechToText();
  final AudioPlayer player = AudioPlayer();

  bool _isAwakeConfirmed = false;
  String _wordsSpoken = "Waiting...";
  String time = '';
  String askString = 'Are you awake? Say, I am awake, to stop the alarm.';
  bool _isListening = false;
  bool _responseReceived = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    time = "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}";
    playAlarm();
  }

  void _initSpeech() async {
    await _speechToText.initialize(
      onStatus: (status) {
        print("Status: $status");
        if (status == 'done' && !_isAwakeConfirmed) {
          playAlarm();
        }
      },
    );
  }

  void playAlarm() async {
    setState(() => _isAwakeConfirmed = false);
    await player.setReleaseMode(ReleaseMode.loop);
    await player.play(AssetSource('alarm.mp3'));
  }

  void stopAlarm() async {
    await player.stop();

    await Future.delayed(const Duration(seconds: 2), () {
      _voiceChallenge(askString);
    });
  }

  void restartAlarm() async {
    await player.stop();
    await flutterTts.speak("You are not awake. Alarm restarting");
    await Future.delayed(Duration(seconds: 2));
    playAlarm();
  }

  Future<void> _voiceChallenge(String sayString) async {
    await flutterTts.setEngine("com.google.android.tts");
    await flutterTts.setLanguage("en-IN");
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.4);

    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(sayString);

    _startListening();
  }

  void _startListening() async {
    _responseReceived = false;
    _isListening = true;

    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 7),
    );

    // Wait for response window
    await Future.delayed(const Duration(seconds: 8), () {
      if (!_responseReceived && !_isAwakeConfirmed) {
        print("No response. Restarting alarm...");

        player.stop();
        restartAlarm();
      }
    });

    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _wordsSpoken = result.recognizedWords;
    });

    if (result.finalResult) {
      _responseReceived = true;
      _checkWakefulness(result.recognizedWords);
    }
  }

  void _checkWakefulness(String words) {
    String voiceInput = words.toLowerCase();
    print("\n\n$voiceInput\n\n");
    if (voiceInput.contains("i am awake") ||
        voiceInput.contains("awake") ||
        voiceInput.contains("yes")) {
      setState(() {
        _isAwakeConfirmed = true;
        _wordsSpoken = "Wake up confirmed!";
      });

      print("User is officially awake.");

      flutterTts.speak("Good morning!");
    } else {
      print("Wrong answer. Restarting alarm...");

      player.stop();
      restartAlarm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("WakeSure")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(time, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 20),
            Text(
              "Heard: $_wordsSpoken",
              style: const TextStyle(color: Colors.blueGrey),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: stopAlarm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
              ),
              child: const Icon(Icons.stop, size: 50),
            ),
            ElevatedButton(
              onPressed: (){
                // NotificationHelper.scheduleNotification('new now', 'first try');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
              ),
              child: const Icon(Icons.send, size: 60),
            ),
          ],
        ),
      ),
    );
  }
}