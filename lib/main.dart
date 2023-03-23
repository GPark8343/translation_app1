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
import 'package:translation_app/screen/history_detail_screen.dart';
import 'package:translation_app/screen/repository_screen.dart';
import 'package:translation_app/screen/set_api_screen.dart';
import 'package:translation_app/screen/setting_screen.dart';
import 'package:translation_app/screen/translation_screen.dart';

void main() {
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
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          home: MyHomePage(),
          routes: {
            HistoryDetailSscreen.routeName: (ctx) => HistoryDetailSscreen(),
            SettingScreen.routeName: (ctx) => SettingScreen(),
            SetApiScreen.routeName: (ctx) => SetApiScreen(),
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

  @override
  void initState() {
    _pages = [
      {
        'page': TranslationScreen(selectPage: (int index) {
          setState(() {
            _selectedPageIndex = index;
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<ApiManage>(context, listen: false).fetchAndSetApi(),
        builder: (context, snapshot) {
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
            bottomNavigationBar: BottomNavigationBar(
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
          );
        });
  }
}
