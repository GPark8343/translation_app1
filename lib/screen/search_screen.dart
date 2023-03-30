import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:translation_app/data/language_list.dart';
import 'package:translation_app/provider/api_manage.dart';
import 'package:translation_app/provider/history_manage.dart';
import 'package:translation_app/provider/user_manage.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  final Function? selectPage;

  SearchScreen({this.selectPage});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _textController = TextEditingController();
  String translatedText = '';
  first() async {
    await Provider.of<UserManage>(context, listen: false).fetchAndSetUser();
    await Provider.of<ApiManage>(context, listen: false).fetchAndSetApi();
  }

  @override
  Widget build(BuildContext context) {
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownButton(
                          value: selectedTargetLanguageCode,
                          items: LanguageList()
                              .translatedLanguageCodeList
                              .map((String code) {
                            return DropdownMenuItem<String>(
                              child: Text(
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              360 *
                                              20.0),
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
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              360 *
                                              20.0,
                                      fontWeight: FontWeight.bold),
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
                            IconButton(
                                onPressed: () {
                                  {
                                    showDialog(
                                        context: context,
                                        builder: (_) {
                                          return AlertDialog(
                                            content: SingleChildScrollView(
                                              child: Column(children: [
                                                _textController.text == ''
                                                    ? Text('번역될 글자가 없습니다.')
                                                    : translatedText == ''
                                                        ? Text('번역을 하지 않았습니다.')
                                                        : (Text('저장이 완료되었습니다.'))
                                              ]),
                                            ),
                                          );
                                        });
                                  }

                                  (_textController.text == '' ||
                                          translatedText == '')
                                      ? null
                                      : Provider.of<HistoryManage>(context,
                                              listen: false)
                                          .addHistory(
                                              'text',
                                              _textController.text,
                                              translatedText,
                                              LanguageList().originalLanguageText(
                                                  selectedOriginalLanguageCode),
                                              LanguageList()
                                                  .translatedLanguageText(
                                                      selectedTargetLanguageCode));
                                  (_textController.text == '' ||
                                          translatedText == '')
                                      ? null
                                      : widget.selectPage!(1);
                                  // _textController.text == '' ? null : widget.selectPage!(1);
                                  // text == ''
                                  //     ? null
                                  //     : setState(() {
                                  //         pageIndex = 1;
                                  //       });
                                },
                                icon: Icon(Icons.save)),
                            IconButton(
                                onPressed: Provider.of<ApiManage>(context,
                                            listen: false)
                                        .items
                                        .isEmpty
                                    ? () {
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
                                    : () async {
                                        if (_textController.text == '') {
                                          showDialog(
                                              context: context,
                                              builder: (_) {
                                                return AlertDialog(
                                                  content:
                                                      SingleChildScrollView(
                                                    child: Column(children: [
                                                      (Text('번역할 글자가 없습니다.'))
                                                    ]),
                                                  ),
                                                );
                                              });
                                          return;
                                        }
                                        var translatedText1 = await translateText(
                                            _textController.text,
                                            selectedTargetLanguageCode); //이거 좀 수정
                                        setState(() {
                                          translatedText = translatedText1;
                                        });
                                      },
                                icon: Image.asset('assets/language.png')),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          controller: _textController,
                          decoration: InputDecoration(
                            labelText: 'input the text',
                            labelStyle: TextStyle(
                              fontSize: MediaQuery.of(context).size.width /
                                  360 *
                                  20, // 글자 크기
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          maxLines: 10,
                          keyboardType: TextInputType.multiline,
                        ),
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
