import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:google_speech/google_speech.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sound_stream/sound_stream.dart';

import 'package:http/http.dart' as http;
import 'package:translation_app/provider/api_manage.dart';

import 'dart:convert';

import 'package:translation_app/provider/history_manage.dart';

class TranslationScreen extends StatefulWidget {
  final Function? selectPage;
  TranslationScreen({this.selectPage});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final RecorderStream _recorder = RecorderStream();
  final ScrollController _scrollController1 = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

  bool recognizing = false;
  bool recognizeFinished = false;
  bool autoScroll = true;
  String text = '';
  String translatedText = '';
  StreamSubscription<List<int>>? _audioStreamSubscription;
  BehaviorSubject<List<int>>? _audioStream;

  @override
  void initState() {
    super.initState();

    _recorder.initialize();
  }

  @override
  Widget build(BuildContext context) {
    String json2 = Provider.of<ApiManage>(context, listen: false).items.isEmpty
        ? ''
        : Provider.of<ApiManage>(context, listen: false).items[0].json;

    Future<String> translateText(String text, String targetLanguage) async {
      String apiKey =
          Provider.of<ApiManage>(context, listen: false).items.isEmpty
              ? ''
              : Provider.of<ApiManage>(context, listen: false).items[0].key;
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

    void streamingRecognize() async {
      await Provider.of<ApiManage>(context, listen: false).fetchAndSetApi();
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

      RecognitionConfig _getConfig() => RecognitionConfig(
          encoding: AudioEncoding.LINEAR16,
          model: RecognitionModel.video,
          enableAutomaticPunctuation: true,
          sampleRateHertz: 16000,
          languageCode: 'en-US');
      String json2 =
          Provider.of<ApiManage>(context, listen: false).items.isEmpty
              ? ''
              : Provider.of<ApiManage>(context, listen: false).items[0].json;
      final serviceAccount = ServiceAccount.fromString(json2);
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
        if (_scrollController1.hasClients && autoScroll) {
          _scrollController1.animateTo(
              _scrollController1.position.maxScrollExtent,
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut);
        }
        if (_scrollController2.hasClients && autoScroll) {
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

    return FutureBuilder(
        future: Provider.of<ApiManage>(context, listen: false).fetchAndSetApi(),
        builder: (context, futureSnapshot) {
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
                          TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.lightBlue[100]),
                            onPressed: () {
                              setState(() {
                                autoScroll = !autoScroll;
                              });
                            },
                            child: Text(
                              autoScroll
                                  ? 'auto-scroll-mode'
                                  : 'non-auto-scroll-mode',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
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
                                        .addHistory(
                                            'record', text, translatedText);
                                text == '' ? null : widget.selectPage!(1);
                              },
                              icon: Icon(Icons.save)),
                          IconButton(
                              onPressed: Provider.of<ApiManage>(context,
                                          listen: false)
                                      .items
                                      .isEmpty
                                  ? () {
                                      Provider.of<ApiManage>(context,
                                              listen: false)
                                          .fetchAndSetApi();
                                      showDialog(
                                          context: context,
                                          builder: (_) {
                                            return AlertDialog(
                                              content: SingleChildScrollView(
                                                child: Column(children: [
                                                  (Text('설정을 먼저 진행해주세요.'))
                                                ]),
                                              ),
                                            );
                                          });
                                    }
                                  : (recognizing
                                      ? Provider.of<ApiManage>(context,
                                                  listen: false)
                                              .items
                                              .isEmpty
                                          ? null
                                          : () {
                                              Provider.of<ApiManage>(context,
                                                      listen: false)
                                                  .fetchAndSetApi();

                                              stopRecording();
                                              showDialog(
                                                  context: context,
                                                  builder: (_) {
                                                    return AlertDialog(
                                                      content:
                                                          SingleChildScrollView(
                                                        child:
                                                            Column(children: [
                                                          (Text('녹음이 정지되었습니다.'))
                                                        ]),
                                                      ),
                                                    );
                                                  });
                                            }
                                      : Provider.of<ApiManage>(context,
                                                  listen: false)
                                              .items
                                              .isEmpty
                                          ? null
                                          : () {
                                              Provider.of<ApiManage>(context,
                                                      listen: false)
                                                  .fetchAndSetApi();
                                              streamingRecognize();
                                              showDialog(
                                                  context: context,
                                                  builder: (_) {
                                                    return AlertDialog(
                                                      content:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                            children: [
                                                              (Text('녹음 중.'))
                                                            ]),
                                                      ),
                                                    );
                                                  });
                                            }),
                              icon:
                                  Icon(recognizing ? Icons.mic_off : Icons.mic))
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
        });
  }
}
