import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:google_speech/google_speech.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sound_stream/sound_stream.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<String> translateText(String text, String targetLanguage) async {
    const apiKey = 'AIzaSyA770N6IzZxM50VrnnVXYn8HPqplf2VC9A';

    final url = Uri.parse(
        'https://translation.googleapis.com/language/translate/v2/' +
            '?q=$text&target=$targetLanguage&key=$apiKey');
    final response = await http.post(url);
    if (response.statusCode == 200) {
      final translatedText = jsonDecode(response.body)['data']['translations']
          [0]['translatedText'];
      return translatedText;
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to translate text');
    }
  }

  final RecorderStream _recorder = RecorderStream();

  bool recognizing = false;
  bool recognizeFinished = false;
  String text = '';
  String translatedText = '';
  StreamSubscription<List<int>>? _audioStreamSubscription;
  BehaviorSubject<List<int>>? _audioStream;

  @override
  void initState() {
    super.initState();

    _recorder.initialize();
  }

  void streamingRecognize() async {
    _audioStream = BehaviorSubject<List<int>>();
    _audioStreamSubscription = _recorder.audioStream.listen((event) {
      _audioStream!.add(event);
    });

    await _recorder.start();

    setState(() {
      recognizing = true;
    });
    final serviceAccount = ServiceAccount.fromString(
        (await rootBundle.loadString('assets/test_service_account.json')));
    final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
    final config = _getConfig();

    final responseStream = speechToText.streamingRecognize(
        StreamingRecognitionConfig(config: config, interimResults: true),
        _audioStream!);

    var responseText = '';
    var translatedResponseText = ''; //

    responseStream.listen((data) async {
      final currentText =
          data.results.map((e) => e.alternatives.first.transcript).join('\n');

      final translatedCurrentText = await translateText(currentText, 'ko'); //

      if (data.results.first.isFinal) {
        responseText += '\n' + currentText;
        translatedResponseText += '\n' + translatedCurrentText;
        setState(() {
          text = responseText;
          translatedText = translatedResponseText;
          recognizeFinished = true;
        });
      } else {
        setState(() {
          text = responseText + '\n' + currentText;
          translatedText =
              translatedResponseText + '\n' + translatedCurrentText;
          recognizeFinished = true;
        });
      }
    }, onDone: () {
      setState(() {
        recognizing = false;
      });
    }).onError((error) {
      print(error);
    });
  }

  void stopRecording() async {
    await _recorder.stop();
    await _audioStreamSubscription?.cancel();
    await _audioStream?.close();
    setState(() {
      recognizing = false;
    });
  }

  RecognitionConfig _getConfig() => RecognitionConfig(
      encoding: AudioEncoding.LINEAR16,
      model: RecognitionModel.video,
      enableAutomaticPunctuation: true,
      sampleRateHertz: 16000,
      languageCode: 'en-US');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                height: 70,
                padding: const EdgeInsets.all(16),
                child: const Text(
                  '한국어:',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(translatedText),
                  ),
                ),
              ),
              Container(
                height: 70,
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'English:',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(text),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Listen',
        onPressed: recognizing ? stopRecording : streamingRecognize,
        child: Icon(recognizing ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}
