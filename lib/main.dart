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
import 'package:flutter/gestures.dart';
import 'package:translation_app/provider/history_manage.dart';
import 'package:translation_app/provider/user_manage.dart';
import 'package:translation_app/screen/history_detail_screen.dart';
import 'package:translation_app/screen/info_screen.dart';
import 'package:translation_app/screen/repository_screen.dart';
import 'package:translation_app/screen/set_api_screen.dart';
import 'package:translation_app/screen/setting_screen.dart';
import 'package:translation_app/screen/translation_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  await initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: HistoryManage(),
          ),
          ChangeNotifierProvider.value(
            value: ApiManage(),
          ),
          ChangeNotifierProvider.value(
            value: UserManage(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          home: MyHomePage(),
          routes: {
            HistoryDetailSscreen.routeName: (ctx) => HistoryDetailSscreen(),
            SettingScreen.routeName: (ctx) => SettingScreen(),
            SetApiScreen.routeName: (ctx) => SetApiScreen(),
            InfoScreen.routeName: (ctx) => InfoScreen(),
          },
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Map<String, Object>> _pages; //
  int _selectedPageIndex = 0;
  bool _isVisible = true; // BottomNavigationBar를 숨기는 상태 변수
  @override
  void initState() {
    _pages = [
      {
        'page': TranslationScreen(
            futureFunction: (String text, String translatedText,
                Future<Null> stopRecording) async {
              await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) {
                    Future.delayed(Duration(seconds: 1), () {
                      Navigator.pop(context);
                    });
                    return WillPopScope(
                      onWillPop: () => Future.value(false),
                      child: AlertDialog(
                        content: SingleChildScrollView(
                          child: Column(children: [
                            (Text(
                                '최대 녹음 가능 시간 300초를 초과하여 녹음이 정지되었습니다.\n1초 뒤에 다시 녹음이 시작됩니다.'))
                          ]),
                        ),
                      ),
                    );
                  });

              text == ''
                  ? null
                  : await Provider.of<HistoryManage>(context, listen: false)
                      .addHistory('record', text, translatedText);
              await stopRecording;
            },
            pageIndex: _selectedPageIndex,
            selectPage: (int index) {
              setState(() {
                _selectedPageIndex = index;
              });
            },
            setState: () {
              setState(() {});
            },
            changeVisible: (bool isVisible) {
              setState(() {
                _isVisible = isVisible;
              });
            }),
        'title': 'translation'
      },
      {'page': RepositoryScreen(), 'title': 'test'},
    ];

    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _changeVisible(bool isVisible) {
    setState(() {
      _isVisible = isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    first() async {
      await Provider.of<UserManage>(context, listen: false).fetchAndSetUser();
      await Provider.of<ApiManage>(context, listen: false).fetchAndSetApi();
      print(Provider.of<UserManage>(context, listen: false).items);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Provider.of<UserManage>(context, listen: false).items.isEmpty)
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (ctx) {
                return WillPopScope(
                  onWillPop: () async => false,
                  child: AlertDialog(
                    title: const Text('개인 정보 동의'),
                    content: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text("회원가입 및 Undersound의 이용약관 및 개인정보처리방침에 동의하시겠습니까?"),
                          GestureDetector(
                            onTap: () {
                              // Navigator.of(context)
                              //     .pushNamed(ServiceScreen.routeName);
                            },
                            child: Card(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                           Text.rich(
                                  TextSpan(
                                      style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline),
                                      //make link blue and underline
                                      text: "앱 서비스 이용약관 보기",
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          //on tap code here, you can navigate to other page or URL
                                          String url =
                                              "https://sites.google.com/view/undersound-terms-of-use";
                                          var urllaunchable = await canLaunch(
                                              url); //canLaunch is from url_launcher package
                                          if (urllaunchable) {
                                            await launch(
                                                url); //launch is from url_launcher package to launch URL
                                          } else {}
                                        }),
                                ),
                                Icon(Icons.arrow_right_alt_rounded)
                              ],
                            )),
                          ),
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.width / 360 * 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.of(context)
                              //     .pushNamed(PrivacyScreen.routeName);
                            },
                            child: Card(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text.rich(
                                  TextSpan(
                                      style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline),
                                      //make link blue and underline
                                      text: "개인정보처리방침 보기",
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          //on tap code here, you can navigate to other page or URL
                                          String url =
                                              "https://sites.google.com/view/undersound-privacy-policy";
                                          var urllaunchable = await canLaunch(
                                              url); //canLaunch is from url_launcher package
                                          if (urllaunchable) {
                                            await launch(
                                                url); //launch is from url_launcher package to launch URL
                                          } else {}
                                        }),
                                ),
                                Icon(Icons.arrow_right_alt_rounded)
                              ],
                            )),
                          ),
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.width / 360 * 20,
                          ),
                          Text('또한 아래와 같은 권한이 필요합니다.'),
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.width / 360 * 10,
                          ),
                          Card(
                            child: Text('1. 마이크(녹음 및 오디오 인식 목적)'),
                          ),
                        
                        ])),
                    actions: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black),
                        onPressed: () {},
                        child: const Text('동의하지 않습니다.'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Provider.of<UserManage>(context, listen: false)
                              .addUser();
                        },
                        child: const Text('동의합니다'),
                      ),
                    ],
                  ),
                );
              });
      });
    }

    return FutureBuilder(
        future: first(),
        builder: (context, snapshot) {
          print(Provider.of<UserManage>(context, listen: false).items);
          return Scaffold(
            appBar: AppBar(
                actions: [
                  IconButton(
                    onPressed: () {
                      Route _createRoute() {
                        return PageRouteBuilder(
                          settings: RouteSettings(arguments: {}),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  InfoScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 1.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        );
                      }

                      Navigator.of(context).push(_createRoute());
                    },
                    icon: Icon(Icons.help_outline_sharp),
                  ),
                  IconButton(
                      onPressed: () {
                        Route _createRoute() {
                          return PageRouteBuilder(
                            settings: RouteSettings(arguments: {}),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    SettingScreen(selectPage: (int index) {
                              setState(() {
                                _selectedPageIndex = index;
                              });
                            }),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(0.0, 1.0);
                              const end = Offset.zero;
                              const curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          );
                        }

                        Navigator.of(context).push(_createRoute());
                      },
                      icon: Icon(Icons.settings))
                ],
                title: Text(
                  _selectedPageIndex == 0 ? '번역' : '기록 보관소',
                )),
            body: SafeArea(child: _pages[_selectedPageIndex]['page'] as Widget),
            bottomNavigationBar: Visibility(
              visible: _isVisible,
              child: BottomNavigationBar(
                  selectedItemColor: Color(0xFF00B6F0),
                  onTap: _selectPage,
                  backgroundColor: Color(0xFFF2F3F8),
                  unselectedItemColor: Colors.black,
                  currentIndex: _selectedPageIndex,
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                        backgroundColor: Theme.of(context).primaryColor,
                        icon: Icon(Icons.home_outlined),
                        label: '홈'),
                    BottomNavigationBarItem(
                        backgroundColor: Theme.of(context).primaryColor,
                        icon: Icon(Icons.file_copy),
                        label: '기록'),
                  ]),
            ),
          );
        });
  }
}
