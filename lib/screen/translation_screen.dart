import 'package:flutter/material.dart';

import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:google_speech/google_speech.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sound_stream/sound_stream.dart';

import 'package:http/http.dart' as http;
import 'package:translation_app/data/language_list.dart';
import 'package:translation_app/provider/api_manage.dart';

import 'dart:convert';

import 'package:translation_app/provider/history_manage.dart';
import 'package:translation_app/provider/user_manage.dart';

class TranslationScreen extends StatefulWidget {
  final int? pageIndex;
  final Function? selectPage;
  final Function? setState;
  final Function? futureFunction;
  final Function? changeVisible;

  TranslationScreen(
      {this.pageIndex,
      this.selectPage,
      this.setState,
      this.futureFunction,
      this.changeVisible});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final RecorderStream _recorder = RecorderStream();
  final ScrollController _scrollController1 = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

  int pageIndex = 0;
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

  Future<void> _requestMicrophonePermission(Function function) async {
    final serviceStatus = await Permission.camera.isGranted;

    bool isCameraOn = serviceStatus == ServiceStatus.enabled;

    final status = await Permission.camera.request();

    if (status == PermissionStatus.granted) {
    } else if (status == PermissionStatus.denied) {
    } else if (status == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
    }
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
        throw Exception('Failed to translate text');
      }
    }

    stopRecording() async {
      widget.changeVisible!(true);
      await _recorder.stop();
      await _audioStreamSubscription?.cancel();
      await _audioStream?.close();
      if (this.mounted) {
        setState(() {
          recognizing = false;
        });
      }
    }

    RecognitionConfig _getConfig(String languageCode) {
      var model = RecognitionModel.basic;
      if (languageCode == 'en-US') {
        model = RecognitionModel.video;
      }
      print(model);
      return RecognitionConfig(
          encoding: AudioEncoding.LINEAR16,
          model: model,
          enableAutomaticPunctuation: true,
          sampleRateHertz: 16000,
          languageCode: languageCode);
    }

    streamingRecognize(String original, String target) async {
      widget.changeVisible!(false);

      Future.delayed(const Duration(seconds: 300), () async {
        if (this.mounted) {
          widget.setState!();
          setState(() {});
        }

        print(recognizing);
        print(widget.pageIndex);
        print(pageIndex);
        if (pageIndex == 0 && recognizing) {
          await widget.futureFunction!(text, translatedText, stopRecording());
          print(recognizing);
          if (recognizing == false) {
            streamingRecognize(original, target);
          }
          //   setState(() {
          //      recognizing = true;//////
          //   });
          //  await streamingRecognize();
        }
      }); //무조건 10초 뒤에 시행되나 두 조건이 모두 만족하므로 스톱한다

      await Provider.of<ApiManage>(context, listen: false).fetchAndSetApi();

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

      String json2 =
          Provider.of<ApiManage>(context, listen: false).items.isEmpty
              ? ''
              : Provider.of<ApiManage>(context, listen: false).items[0].json;
      final serviceAccount = ServiceAccount.fromString(json2);
      final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
      final config = _getConfig(original); //이거 수정

      final responseStream = speechToText.streamingRecognize(
          StreamingRecognitionConfig(config: config, interimResults: true),
          _audioStream!);

      var responseText = '';
      var translatedResponseText = ''; //
      if (recognizing) {
        responseStream.listen((data) async {
          final currentText = data.results
              .map((e) => e.alternatives.first.transcript)
              .join('\n');
          // currentText == '' ? print('no') : print('okay');
          final translatedCurrentText = currentText == ''
              ? ''
              : await translateText(currentText, target)
                  .onError((error, stackTrace) => ''); // onerror하는 이유: 계속 에러 나서
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
    }

    first() async {
      await Provider.of<UserManage>(context, listen: false).fetchAndSetUser();
      await Provider.of<ApiManage>(context, listen: false).fetchAndSetApi();
    }

    return FutureBuilder(
        future: first(),
        builder: (context, futureSnapshot) {
          if (Provider.of<UserManage>(context, listen: false).items.isEmpty) {
            return Center();
          } else {
            String selectedOriginalLanguageCode =
                Provider.of<UserManage>(context, listen: false)
                    .items[0]
                    .originalLanguage;
            String selectedTargetLanguageCode =
                Provider.of<UserManage>(context, listen: false)
                    .items[0]
                    .targetLanguage;
            return Center(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width / 360 * 70,
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width / 360 * 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        DropdownButton(
                          value: selectedTargetLanguageCode,
                          items: LanguageList()
                              .translatedLanguageCodeList
                              .map((String code) {
                            return DropdownMenuItem<String>(
                              child: Text(
                                  '${LanguageList().translatedLanguageText(code)}'),
                              value: code,
                            );
                          }).toList(),
                          onChanged: (dynamic value) {
                            print(value);
                            print(
                                Provider.of<UserManage>(context, listen: false)
                                    .items[0]
                                    .targetLanguage);

                            Provider.of<UserManage>(context, listen: false)
                                .changeTranslatedLanguage(
                              Provider.of<UserManage>(context, listen: false)
                                  .items[0],
                              value,
                            );
                            Provider.of<UserManage>(context, listen: false)
                                .fetchAndSetUser();
                            setState(() {});
                          },
                        ),
                      ],
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
                    height: MediaQuery.of(context).size.width / 360 * 70,
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width / 360 * 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownButton(
                          value: selectedOriginalLanguageCode,
                          items: LanguageList()
                              .originalLanguageCodeList
                              .map((String code) {
                            return DropdownMenuItem<String>(
                              child: Text(
                                  '${LanguageList().originalLanguageText(code)}'),
                              value: code,
                            );
                          }).toList(),
                          onChanged: (dynamic value) {
                            print(value);
                            print(
                                Provider.of<UserManage>(context, listen: false)
                                    .items[0]
                                    .originalLanguage);

                            Provider.of<UserManage>(context, listen: false)
                                .changeOriginalLanguage(
                              Provider.of<UserManage>(context, listen: false)
                                  .items[0],
                              value,
                            );
                            Provider.of<UserManage>(context, listen: false)
                                .fetchAndSetUser();
                            setState(() {});
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.amber[100]),
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
                                  {
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
                                  }
                                  stopRecording();
                                  text == ''
                                      ? null
                                      : Provider.of<HistoryManage>(context,
                                              listen: false)
                                          .addHistory(
                                              'record', text, translatedText);
                                  text == '' ? null : widget.selectPage!(1);
                                  text == ''
                                      ? null
                                      : setState(() {
                                          pageIndex = 1;
                                        });
                                },
                                icon: Icon(Icons.save)),
                            IconButton(
                                onPressed: (Provider.of<ApiManage>(context,
                                            listen: false)
                                        .items
                                        .isEmpty
                                    ? () async {
                                        final serviceStatus = await Permission
                                            .microphone.isGranted;

                                        bool isMicrophoneOn = serviceStatus ==
                                            ServiceStatus.enabled;

                                        final status = await Permission
                                            .microphone
                                            .request();

                                        if (status ==
                                            PermissionStatus.granted) {
                                          Provider.of<ApiManage>(context,
                                                  listen: false)
                                              .fetchAndSetApi();

                                          showDialog(
                                              context: context,
                                              builder: (_) {
                                                return AlertDialog(
                                                  content:
                                                      SingleChildScrollView(
                                                    child: Column(children: [
                                                      (Text('설정을 먼저 진행해주세요.'))
                                                    ]),
                                                  ),
                                                );
                                              });
                                        } else if (status ==
                                            PermissionStatus.denied) {
                                        } else if (status ==
                                            PermissionStatus
                                                .permanentlyDenied) {
                                          await openAppSettings();
                                        }
                                      }
                                    : (recognizing
                                        ? (Provider.of<ApiManage>(context,
                                                    listen: false)
                                                .items
                                                .isEmpty
                                            ? null
                                            : () async {
                                                final serviceStatus =
                                                    await Permission
                                                        .microphone.isGranted;

                                                bool isMicrophoneOn =
                                                    serviceStatus ==
                                                        ServiceStatus.enabled;

                                                final status = await Permission
                                                    .microphone
                                                    .request();

                                                if (status ==
                                                    PermissionStatus.granted) {
                                                  Provider.of<ApiManage>(
                                                          context,
                                                          listen: false)
                                                      .fetchAndSetApi();

                                                  stopRecording();
                                                  showDialog(
                                                      context: context,
                                                      builder: (_) {
                                                        return AlertDialog(
                                                          content:
                                                              SingleChildScrollView(
                                                            child: Column(
                                                                children: [
                                                                  (Text(
                                                                      '녹음이 정지되었습니다.'))
                                                                ]),
                                                          ),
                                                        );
                                                      });
                                                } else if (status ==
                                                    PermissionStatus.denied) {
                                                } else if (status ==
                                                    PermissionStatus
                                                        .permanentlyDenied) {
                                                  await openAppSettings();
                                                }
                                              })
                                        : (Provider.of<ApiManage>(context,
                                                    listen: false)
                                                .items
                                                .isEmpty
                                            ? null
                                            : () async {
                                                final serviceStatus =
                                                    await Permission
                                                        .microphone.isGranted;

                                                bool isMicrophoneOn =
                                                    serviceStatus ==
                                                        ServiceStatus.enabled;

                                                final status = await Permission
                                                    .microphone
                                                    .request();

                                                if (status ==
                                                    PermissionStatus.granted) {
                                                  await Provider.of<UserManage>(
                                                          context,
                                                          listen: false)
                                                      .fetchAndSetUser();
                                                  Provider.of<ApiManage>(
                                                          context,
                                                          listen: false)
                                                      .fetchAndSetApi();
                                                  var originalLanguage =
                                                      Provider.of<UserManage>(
                                                              context,
                                                              listen: false)
                                                          .items[0]
                                                          .originalLanguage;
                                                  var targetLanguage =
                                                      Provider.of<UserManage>(
                                                              context,
                                                              listen: false)
                                                          .items[0]
                                                          .targetLanguage;
                                                  streamingRecognize(
                                                      originalLanguage,
                                                      targetLanguage); //첫번째: stt, 두번쨰 번역

//https://cloud.google.com/speech-to-text/docs/speech-to-text-supported-languages?hl=ko

                                                  //https://cloud.google.com/translate/docs/languages?hl=ko
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (_) {
                                                        Future.delayed(
                                                            Duration(
                                                                seconds: 1),
                                                            () {
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                        return WillPopScope(
                                                          onWillPop: () =>
                                                              Future.value(
                                                                  false),
                                                          child: AlertDialog(
                                                            content:
                                                                SingleChildScrollView(
                                                              child: Column(
                                                                  children: [
                                                                    (Text(
                                                                        '녹음 중.'))
                                                                  ]),
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                } else if (status ==
                                                    PermissionStatus.denied) {
                                                } else if (status ==
                                                    PermissionStatus
                                                        .permanentlyDenied) {
                                                  await openAppSettings();
                                                }
                                              }))),
                                icon: Icon(
                                    recognizing ? Icons.mic_off : Icons.mic))
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
        });
  }
}
