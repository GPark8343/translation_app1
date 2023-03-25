import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translation_app/provider/api_manage.dart';
import 'package:translation_app/screen/set_api_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatelessWidget {
  static const routeName = '/setting';
  final Function? selectPage;
  SettingScreen({this.selectPage});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Api 등록'), actions: [
        Provider.of<ApiManage>(context, listen: false).items.isEmpty
            ? TextButton(
                onPressed: () {
                  Route _createRoute() {
                    return PageRouteBuilder(
                      settings: RouteSettings(arguments: {}),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          SetApiScreen(selectPage: selectPage),
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
                child: Text(
                  '만들기',
                  style: TextStyle(color: Colors.black),
                ))
            : Container()
      ]),
      body: Center(
          child: FutureBuilder(
              future: Provider.of<ApiManage>(context, listen: false)
                  .fetchAndSetApi(),
              builder: (context, futureSnapshot) {
                // print(Provider.of<ApiManage>(context, listen: false).items[0].json);
                return Consumer<ApiManage>(
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '아직 api 연결이 안돼있습니다. 지금 만들어보세요',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width / 360 * 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                    builder: (ctx, greatApis, ch) {
                      return greatApis.items.length == 0
                          ? Text(
                              '아직 api 연결이 안돼있습니다. 지금 만들어보세요',
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width /
                                      360 *
                                      15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Card(
                                  child: ListTile(
                                    onLongPress: () {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return AlertDialog(
                                              title: const Text('진짜로 지우시겠습니까?'),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                  style: ElevatedButton
                                                      .styleFrom(),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('취소하기'),
                                                ),
                                                ElevatedButton(
                                                  style: ElevatedButton
                                                      .styleFrom(),
                                                  onPressed: () async {
                                                    Provider.of<ApiManage>(
                                                            context,
                                                            listen: false)
                                                        .deleteApi(Provider.of<
                                                                    ApiManage>(
                                                                context,
                                                                listen: false)
                                                            .items[0]
                                                            .id);
                                                    await Provider.of<
                                                                ApiManage>(
                                                            context,
                                                            listen: false)
                                                        .fetchAndSetApi();
                                                    Navigator.of(context).pop();
                                                    selectPage!(1);

                                                    showDialog(
                                                        context: context,
                                                        builder: (_) {
                                                          return AlertDialog(
                                                            content:
                                                                SingleChildScrollView(
                                                              child: Text(
                                                                  '삭제가 완료되었습니다.\n다시 화면을 로딩해주세요'),
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  child: const Text('삭제하기'),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    title: Text(
                                      '설정 완료',
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              360 *
                                              15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      (greatApis.items[0].createdAt) as String,
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              360 *
                                              12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onTap: () {},
                                  ),
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
                                  height: MediaQuery.of(context).size.width /
                                      360 *
                                      100,
                                )
                              ],
                            );
                    });
              })),
    );
  }
}
