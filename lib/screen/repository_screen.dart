import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translation_app/provider/history_manage.dart';
import 'package:translation_app/screen/history_detail_screen.dart';
import 'package:intl/intl.dart';

class RepositoryScreen extends StatelessWidget {
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<HistoryManage>(context, listen: false)
            .fetchAndSetHistories(),
        builder: (context, futureSnapshot) {
          if (Provider.of<HistoryManage>(context, listen: false)
              .items
              .isEmpty) {
            return Center();
          } else {
            return Consumer<HistoryManage>(
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '아직 스토리가 없습니다. 지금 만들어보세요',
                      style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width / 360 * 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
                builder: (ctx, greatHistories, ch) {
                  var sortedItems = greatHistories.items.reversed.toList();
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: sortedItems.length,
                    itemBuilder: (ctx, i) => Card(
                      child: ListTile(
                        title: Text(
                          sortedItems[i].title,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width / 360 * 15,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          dateFormat.format(
                                  DateTime.parse(sortedItems[i].createdAt))
                              as String,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width / 360 * 12,
                              fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          ('${sortedItems[i].originalLanguage} -> ${sortedItems[i].translatedLanguage}')
                              as String,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width / 360 * 12,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Route _createRoute() {
                            return PageRouteBuilder(
                              settings: RouteSettings(arguments: {
                                'history_id': sortedItems[i].id,
                                'history_title': sortedItems[i].title,
                                'history_text': sortedItems[i].text,
                                'history_translatedText':
                                    sortedItems[i].translatedText,
                                'history_createdAt': sortedItems[i].createdAt,
                                'history_originalLanguage':
                                    sortedItems[i].originalLanguage,
                                'history_translatedLanguage':
                                    sortedItems[i].translatedLanguage,
                              }),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      HistoryDetailSscreen(),
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
                      ),
                    ),
                  );
                });
          }
        });
  }
}
