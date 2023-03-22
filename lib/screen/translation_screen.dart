// import 'package:flutter/material.dart';

// class TranslationScreen extends StatefulWidget {
//   const TranslationScreen({super.key});

//   @override
//   State<TranslationScreen> createState() => _TranslationScreenState();
// }

// class _TranslationScreenState extends State<TranslationScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Center(
//           child: Column(
//             children: [
//               Container(
//                 height: 70,
//                 padding: const EdgeInsets.all(16),
//                 child: const Text(
//                   '한국어:',
//                   style: TextStyle(fontSize: 20.0),
//                 ),
//               ),
//               Expanded(
//                 child: SingleChildScrollView(
//                   controller: _scrollController1,
//                   physics: AlwaysScrollableScrollPhysics(),
//                   child: Container(
//                     width: MediaQuery.of(context).size.width,
//                     child: Text(translatedText),
//                   ),
//                 ),
//               ),
//               Container(
//                 height: 70,
//                 padding: const EdgeInsets.all(16),
//                 child: const Text(
//                   'English:',
//                   style: TextStyle(fontSize: 20.0),
//                 ),
//               ),
//               Expanded(
//                 child: SingleChildScrollView(
//                   controller: _scrollController2,
//                   physics: AlwaysScrollableScrollPhysics(),
//                   child: Container(
//                     width: MediaQuery.of(context).size.width,
//                     child: Text(text),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//   }
// }