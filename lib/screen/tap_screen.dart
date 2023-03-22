// import 'package:flutter/material.dart';
// import 'dart:async';

// import 'package:flutter/services.dart';
// import 'package:google_speech/google_speech.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:sound_stream/sound_stream.dart';

// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class TapScreen extends StatefulWidget {
//   TapScreen({Key? key}) : super(key: key);

//   @override
//   _TapScreenState createState() => _TapScreenState();
// }

// class _TapScreenState extends State<TapScreen> {

  
//   late List<Map<String, Object>> _pages; //
//   int _selectedPageIndex = 1;

//   @override
//   void initState() {
   
//     _pages = [
//         {'page': InstaScreen(), 'title': 'upload'},
//       {'page': DesignCourseHomeScreen(), 'title': 'test'},
//       {'page': ChallengeScreen(), 'title': 'challenge'},
//     ];

//     super.initState();
//   }



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(actions: [
//         IconButton(onPressed: () {}, icon: Icon(Icons.save)),
//         IconButton(
//             onPressed: () {
//               recognizing ? stopRecording : streamingRecognize;
//             },
//             icon: Icon(recognizing ? Icons.mic_off : Icons.mic))
//       ]),
//       body: 
//       bottomNavigationBar: BottomNavigationBar(items: []),
//     );
//   }
// }
