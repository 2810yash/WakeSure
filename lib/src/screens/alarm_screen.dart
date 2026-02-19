import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {

  final FlutterTts flutterTts = FlutterTts();
  final SpeechToText _speechToText = SpeechToText();
  final AudioPlayer player = AudioPlayer();

  bool _speechEnabled = false;
  String _wordsSpoken = "Tap the mic and say something...";
  late DateTime now;
  String time = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
    now = DateTime.now();
    time = "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
    playAlarm();
  }

  void playAlarm() async{
    await player.setReleaseMode(ReleaseMode.loop);
    await player.play(AssetSource('alarm.mp3'));
  }
  void stopAlarm() async{
    await player.stop();
    Future.delayed(Duration(seconds: 3), () {
      _speak();
    });
  }
  /// Initialize Speech to Text
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }
  /// Start listening
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }
  /// Stop listening
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }
  /// This callback triggers as you speak
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _wordsSpoken = result.recognizedWords;
      print("\n\n$_wordsSpoken\n\n");
      _checkSpeech(_wordsSpoken);
    });
  }

  void _checkSpeech(String words){
    words = words.toLowerCase();
    if (words.contains("yes") || words.contains("i am awake")) {
      print("\n\nUser is awake!\n\n");
    } else {
      playAlarm();
    }
  }

  Future<void> _speak() async {
    await flutterTts.setEngine("com.google.android.tts");
    await flutterTts.setLanguage("en-IN");
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak("Are You Awake?");
    await Future.delayed(Duration(seconds: 3));
    await flutterTts.speak("Answer with, I am awake");
    await Future.delayed(Duration(seconds: 1));
    _startListening();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Alarm")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(time),
            const SizedBox(height: 20.0),
            ElevatedButton(onPressed: stopAlarm, child: Icon(Icons.close))
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   // onPressed: _speechToText.isNotListening ? _startListening : _stopListening,
      //   onPressed: stopAlarm,
      //   tooltip: 'Listen',
      //   child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      // ),
    );
  }
}
