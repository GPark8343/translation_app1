import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:google_speech/google_speech.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sound_stream/sound_stream.dart';

import 'package:http/http.dart' as http;
import 'package:translation_app/provider/bottom_manage.dart';
import 'dart:convert';

import 'package:translation_app/provider/history_manage.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  Future<String> translateText(String text, String targetLanguage) async {
    const apiKey = 'AIzaSyC7J7y9M009gpDOq4A5qIxn1b9M-mdPiSU';

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
  final ScrollController _scrollController1 = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

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
    //  Provider.of<BottomManage>(context, listen: false).changeFalse();
    _audioStream = BehaviorSubject<List<int>>();
    _audioStreamSubscription = _recorder.audioStream.listen((event) {
      _audioStream!.add(event);
    });

    await _recorder.start();
    if (this.mounted) {
      setState(() {
        recognizing = true;
      });
    }
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
      if (_scrollController1.hasClients) {
        _scrollController1.animateTo(
            _scrollController1.position.maxScrollExtent,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut);
      }
      if (_scrollController2.hasClients) {
        _scrollController2.animateTo(
            _scrollController2.position.maxScrollExtent,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut);
      }

      if (data.results.first.isFinal) {
        responseText += '\n' + currentText;
        translatedResponseText += '\n' + translatedCurrentText;
        if (this.mounted) {
          setState(() {
            text = responseText;
            translatedText = translatedResponseText;
            recognizeFinished = true;
          });
        }
      } else {
        if (this.mounted) {
          setState(() {
            text = responseText + '\n' + currentText;
            translatedText =
                translatedResponseText + '\n' + translatedCurrentText;
            recognizeFinished = true;
          });
        }
      }
    }, onDone: () {
      if (this.mounted) {
        setState(() {
          recognizing = false;
        });
      }
    });
  }

  void stopRecording() async {
    // Provider.of<BottomManage>(context, listen: false).changeTrue();
    await _recorder.stop();
    await _audioStreamSubscription?.cancel();
    await _audioStream?.close();
    if (this.mounted) {
      setState(() {
        recognizing = false;
      });
    }
  }

  RecognitionConfig _getConfig() => RecognitionConfig(
      encoding: AudioEncoding.LINEAR16,
      model: RecognitionModel.video,
      enableAutomaticPunctuation: true,
      sampleRateHertz: 16000,
      languageCode: 'en-US');

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            height: 70,
            padding: const EdgeInsets.all(16),
            child: const Text(
              textAlign: TextAlign.start,
              '한국어:',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController1,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'English:',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 20.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  content: SingleChildScrollView(
                                    child: Column(children: [
                                      text == ''
                                          ? Text('번역된 글자가 없습니다.')
                                          : (Text('기록 저장이 완료되었습니다.'))
                                    ]),
                                  ),
                                );
                              });
                          stopRecording();
                          text == ''
                              ? null
                              : Provider.of<HistoryManage>(context,
                                      listen: false)
                                  .addHistory('example', text, translatedText);
                        },
                        icon: Icon(Icons.save)),
                    IconButton(
                        onPressed: recognizing
                            ? () {
                                stopRecording();
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        content: SingleChildScrollView(
                                          child: Column(children: [
                                            (Text('녹음이 정지되었습니다.'))
                                          ]),
                                        ),
                                      );
                                    });
                              }
                            : () {
                                streamingRecognize();
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        content: SingleChildScrollView(
                                          child: Column(
                                              children: [(Text('녹음 중.'))]),
                                        ),
                                      );
                                    });
                              },
                        icon: Icon(recognizing ? Icons.mic_off : Icons.mic))
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController2,
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Text(text),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
