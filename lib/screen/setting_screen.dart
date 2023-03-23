import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translation_app/provider/api_manage.dart';
import 'package:translation_app/screen/set_api_screen.dart';

class SettingScreen extends StatelessWidget {
  static const routeName = '/setting';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        Provider.of<ApiManage>(context, listen: false).items.isEmpty
            ? TextButton(
                onPressed: () {
                  Route _createRoute() {
                    return PageRouteBuilder(
                      settings: RouteSettings(arguments: {}),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          SetApiScreen(),
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
                          : Card(
                              child: ListTile(
                                onLongPress: () {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return AlertDialog(
                                          title: const Text('진짜로 지우시겠습니까?'),
                                          actions: <Widget>[
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('취소하기'),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(),
                                              onPressed: () async {
                                                Provider.of<ApiManage>(context,
                                                        listen: false)
                                                    .deleteApi(
                                                        Provider.of<ApiManage>(
                                                                context,
                                                                listen: false)
                                                            .items[0]
                                                            .id);
                                                await Provider.of<ApiManage>(
                                                        context,
                                                        listen: false)
                                                    .fetchAndSetApi();
                                                Navigator.of(context).pop();

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
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              360 *
                                              15,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  (greatApis.items[0].createdAt) as String,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              360 *
                                              12,
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  // Route _createRoute() {
                                  //   return PageRouteBuilder(
                                  //     settings: RouteSettings(arguments: {
                                  //       'api_id': greatApis.items[0].id,
                                  //       'api_key': greatApis.items[0].key,
                                  //       'api_json': greatApis.items[0].json,
                                  //       'api_createdAt':
                                  //           greatApis.items[0].createdAt,
                                  //     }),
                                  //     pageBuilder: (context, animation,
                                  //             secondaryAnimation) =>
                                  //         ApiDetailSscreen(),
                                  //     transitionsBuilder: (context, animation,
                                  //         secondaryAnimation, child) {
                                  //       const begin = Offset(0.0, 1.0);
                                  //       const end = Offset.zero;
                                  //       const curve = Curves.ease;

                                  //       var tween = Tween(
                                  //               begin: begin, end: end)
                                  //           .chain(CurveTween(curve: curve));

                                  //       return SlideTransition(
                                  //         position: animation.drive(tween),
                                  //         child: child,
                                  //       );
                                  //     },
                                  //   );
                                  // }

                                  // Navigator.of(context).push(_createRoute());
                                },
                              ),
                            );
                    });
              })),
    );
  }
}
