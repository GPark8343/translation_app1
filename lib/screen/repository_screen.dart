import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translation_app/provider/history_manage.dart';
import 'package:translation_app/screen/history_detail_screen.dart';

class RepositoryScreen extends StatelessWidget {
  const RepositoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: Provider.of<HistoryManage>(context,
                                          listen: false).fetchAndSetHistories(),
      builder: (context,futureSnapshot) {
        return Consumer<HistoryManage>(
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '아직 스토리가 없습니다. 지금 만들어보세요',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 360 * 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )),
            builder: (ctx, greatHistories, ch) {
              return ListView.builder(reverse: true,
                shrinkWrap: true,
                itemCount: greatHistories.items.length,
                itemBuilder: (ctx, i) => Card(
                  child: ListTile(
                    title: Text(
                      greatHistories.items[i].title,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 360 * 15,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      (greatHistories.items[i].createdAt) as String,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 360 * 12,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Route _createRoute() {
                        return PageRouteBuilder(
                          settings: RouteSettings(arguments: {
                            'history_id': greatHistories.items[i].id,
                            'history_title': greatHistories.items[i].title,
                            'history_text': greatHistories.items[i].text,
                            'history_translatedText':
                                greatHistories.items[i].translatedText,
                            'history_createdAt': greatHistories.items[i].createdAt,
                          }),
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              HistoryDetailSscreen(),
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
                  ),
                ),
              );
            });
      }
    );
  }
}