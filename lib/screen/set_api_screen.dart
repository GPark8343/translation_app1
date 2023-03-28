import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translation_app/provider/api_manage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class SetApiScreen extends StatefulWidget {
  static const routeName = '/set-api';
  final Function? selectPage;
  SetApiScreen({this.selectPage});

  @override
  State<SetApiScreen> createState() => _SetApiScreenState();
}

class _SetApiScreenState extends State<SetApiScreen> {
  final _priceFocusNode = FocusNode();
  final _jsonFocusNode = FocusNode();
  final _keyController = TextEditingController();
  final _jsonController = TextEditingController();

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _jsonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('setting'), actions: []),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width / 360 * 50,
                ),
                Text.rich(
                  TextSpan(
                      style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                      //make link blue and underline
                      text: "api key랑 json 가져오는 법 알아보기",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          //on tap code here, you can navigate to other page or URL
                          String url =
                              "https://blog.naver.com/genius8343/223055543379";
                          var urllaunchable = await canLaunch(
                              url); //canLaunch is from url_launcher package
                          if (urllaunchable) {
                            await launch(
                                url); //launch is from url_launcher package to launch URL
                          } else {}
                        }),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 360 * 50,
                ),
                Text('api key와 json을 입력하세요'),
                TextFormField(
                  controller: _keyController,
                  decoration: InputDecoration(labelText: 'api key'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 360 * 10,
                ),
                TextFormField(
                  controller: _jsonController,
                  decoration: InputDecoration(labelText: 'json'),
                  keyboardType: TextInputType.multiline,
                  focusNode: _jsonFocusNode,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 360 * 100,
                ),
                TextButton(
                    onPressed: () async {
                      if (_keyController.text.isEmpty ||
                          _jsonController.text.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                content: SingleChildScrollView(
                                  child: Column(children: [
                                    Text('key와 json을 모두 입력해주세요.')
                                  ]),
                                ),
                              );
                            });
                        print('빈 필드는 작성 못하게 해야 함.');
                        return;
                      } else if (_keyController.text.length != 39) {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                content: SingleChildScrollView(
                                  child: Column(
                                      children: [Text('key는 총 39자여야 합니다.')]),
                                ),
                              );
                            });
                        print('key는 총 39자여야 합니다.');
                        return;
                      } else if (!_jsonController.text.startsWith('{') ||
                          !_jsonController.text.endsWith('}')) {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                content: SingleChildScrollView(
                                  child: Column(children: [
                                    Text('json은 { 로 시작하고 } 로 끝나야 합니다.')
                                  ]),
                                ),
                              );
                            });
                        print('json은 { 로 시작하고 } 로 끝나야 합니다.');
                        return;
                      }
                      //showdiaog로 경고하기

                      await Provider.of<ApiManage>(context, listen: false)
                          .addApi(_keyController.text, _jsonController.text);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      widget.selectPage!(1);
                      await Provider.of<ApiManage>(context, listen: false)
                          .fetchAndSetApi();
                    },
                    child: Text('입력 완료'))
              ],
            ),
          ),
        ));
  }
}
