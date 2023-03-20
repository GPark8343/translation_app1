// import 'package:flutter/material.dart';
// import 'package:translator/translator.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:speech_to_text/speech_to_text.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Translation();
//   }
// }

// class Translation extends StatefulWidget {
//   const Translation({super.key});

//   @override
//   State<Translation> createState() => _TranslationState();
// }

// class _TranslationState extends State<Translation> {
//   String translated = 'Translation';
//   final speech = SpeechToText();
//   bool _isListening = false;

//   @override
//   void initState() {
//     super.initState();
//     _initSpeech();
//   }

//   /// This has to happen only once per app
//   void _initSpeech() async {
//     await speech.initialize();
//     setState(() {});
//   }

//   void mainFunction() {
//     speech.listen(
//       onResult: (result) async {
//         final text = result.recognizedWords;

//         var translatedText = await translateText(text, 'ko');
//         setState(() {
//           translated = translatedText;
//         });
//         // 변환된 텍스트를 처리하고 Google Cloud Translate API를 호출하여 번역합니다.
//       },
//     );
//   }

//   void stopFunction() {
//     speech.stop();
//   }

//   Future<String> translateText(String text, String targetLanguage) async {
//     const apiKey = 'AIzaSyA770N6IzZxM50VrnnVXYn8HPqplf2VC9A';

//     final url = Uri.parse(
//         'https://translation.googleapis.com/language/translate/v2/' +
//             '?q=$text&target=$targetLanguage&key=$apiKey');
//     final response = await http.post(url);
//     if (response.statusCode == 200) {
//       final translatedText = jsonDecode(response.body)['data']['translations']
//           [0]['translatedText'];
//       return translatedText;
//     } else {
//       print(response.statusCode);
//       print(response.body);
//       throw Exception('Failed to translate text');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Card(
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Text('English',
//                 style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
//             SizedBox(
//               height: 8,
//             ),
//             Row(
//               children: [
//                 IconButton(
//                     onPressed: () async {
//                       if (!_isListening) {
//                         var available = await speech.initialize();
//                         if (available) {
//                           setState(() {
//                             _isListening = true;
//                           });
//                           while (_isListening = true) {
//                             mainFunction();
//                           }
//                         }
//                       }

//                       //       _speechEnabled == false;
//                       // while (_speechEnabled == false) {
//                       //    Future.delayed(Duration(seconds: 1),);
//                       //   startListening();
//                       // }
//                     },
//                     icon: Icon(Icons.mic)),
//                 IconButton(
//                     onPressed: () {
//                       setState(() {
//                         _isListening = false;
//                       });
//                       stopFunction();
//                     },
//                     icon: Icon(Icons.mic_off))
//               ],
//             ),
//             // TextField(
//             //   decoration: InputDecoration(hintText: 'Enter text'),
//             //   onChanged: (text) async {
//             //     var translatedText = await translateText(text, 'en');
//             //     setState(() {
//             //       translated = translatedText;
//             //     });
//             //   },
//             // ),
//             Divider(
//               height: 32,
//             ),
//             Text(
//               translated,
//               style: TextStyle(
//                   fontSize: 36,
//                   color: Colors.lightBlueAccent,
//                   fontWeight: FontWeight.bold),
//             )
//           ],
//         ),
//       ),
//     ));
//   }
// }

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  SpeechToText _speechToText = SpeechToText();
  final String _selectedLocaleId = 'en';
  bool _speechEnabled = false;
  bool _speechAvailable = false;
  String _lastWords = '';
  String _currentWords = '';
  String _lastWords2 = '';
  String _currentWords2 = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {});
    _startListening();
    debugPrint(error.errorMsg.toString());
    // showDialog(
    //     context: context,
    //     builder: (_) {
    //       return AlertDialog(
    //         content: SingleChildScrollView(
    //           child: Column(children: [Text('에러 발생 다시 시도해주세요.')]),
    //         ),
    //       );
    //     });
  }

  void statusListener(String status) async {
    debugPrint("status $status");
    if (status == "done" && _speechEnabled) {
      setState(() {
        _lastWords += " $_currentWords";
        _currentWords = "";
        _lastWords2 += " $_currentWords2";
        _currentWords2 = "";
        _speechEnabled = false;
      });
      await _startListening();
    }
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechAvailable = await _speechToText.initialize(
        onError: errorListener, onStatus: statusListener);
    setState(() {});
  }

  /// Each time to start a speech recognition session
  Future _startListening() async {
    debugPrint("=================================================");
    await _stopListening();
    // await Future.delayed(const Duration(milliseconds: 5));
    await _speechToText.listen(
        localeId: _selectedLocaleId,
        onResult: _onSpeechResult,
        cancelOnError: false,
        partialResults: true,
        listenMode: ListenMode.dictation);
    setState(() {
      _speechEnabled = true;
    });
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  Future _stopListening() async {
    setState(() {
      _speechEnabled = false;
    });
    await _speechToText.stop();
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) async {
    final text = result.recognizedWords;
    var translatedText = await translateText(text, 'ko');
    setState(() {
      _currentWords = translatedText;
      _currentWords2 = text;
    });
  }

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

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  // void _onSpeechResult(SpeechRecognitionResult result) {
  //   setState(() {
  //     _lastWords = result.recognizedWords;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    '한국어:',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
             
                      Text(
                        _lastWords.isNotEmpty
                            ? '$_lastWords \n$_currentWords \n'
                            : _speechAvailable
                                ? 'Tap the microphone to start listening...'
                                : 'Speech not available',
                      ),
                   
             
              
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: const Text(
                          '영어:',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    
                          Text(
                            _lastWords2.isNotEmpty
                                ? '$_lastWords2 \n$_currentWords2 \n'
                                : _speechAvailable
                                    ? 'Tap the microphone to start listening...'
                                    : 'Speech not available',
                        
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}
