// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:translator/translator.dart';

// Future<String> translateText(String text, String targetLanguage) async {
//   final response = await http.post(
//     Uri.parse('https://translation.googleapis.com/language/translate/v2'),
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode({
//       'q': text,
//       'target': targetLanguage,
//       'key': '[YOUR_API_KEY]',
//     }),
//   );
//   if (response.statusCode == 200) {
//     final translatedText =
//         jsonDecode(response.body)['data']['translations'][0]['translatedText'];
//     return translatedText;
//   } else {
//     throw Exception('Failed to translate text');
//   }
// }

// class Translation extends StatefulWidget {
//   const Translation({super.key});

//   @override
//   State<Translation> createState() => _TranslationState();
// }

// class _TranslationState extends State<Translation> {
//   String translated = 'Translation';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Card(
//       child: ListView(
//         children: [
//           Text('English',
//               style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
//           SizedBox(
//             height: 8,
//           ),
//           TextField(
//             decoration: InputDecoration(hintText: 'Enter text'),
//             onChanged: (text) async {
//               await 'Hello'.translate();
//             },
//           ),
//           Divider(
//             height: 32,
//           ),
//           Text(
//             translated,
//             style: TextStyle(
//                 fontSize: 36,
//                 color: Colors.lightBlueAccent,
//                 fontWeight: FontWeight.bold),
//           )
//         ],
//       ),
//     ));
//   }
// }
