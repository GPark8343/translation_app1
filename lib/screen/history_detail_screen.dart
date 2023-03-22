import 'package:flutter/material.dart';

class HistoryDetailSscreen extends StatelessWidget {
  static const routeName = '/history-detail';
  const HistoryDetailSscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyId =
        (ModalRoute.of(context)?.settings.arguments as Map)['history_id'];
    final historyTitle =
        (ModalRoute.of(context)?.settings.arguments as Map)['history_title'];
    final historyText =
        (ModalRoute.of(context)?.settings.arguments as Map)['history_text'];
    final historyTranslatedText = (ModalRoute.of(context)?.settings.arguments
        as Map)['history_translatedText'];
    final historyCreatedAt = (ModalRoute.of(context)?.settings.arguments
        as Map)['history_createdAt'];
    DateTime dateTime = DateTime.parse(historyCreatedAt);
    return Scaffold(
        appBar: AppBar(title: Text('${historyTitle}')),
        body: SafeArea(
            child: Center(
          child: Column(
            children: [
              Container(
                height: 70,
                padding: const EdgeInsets.all(16),
                child: Text(
                  textAlign: TextAlign.start,
                  '${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일 ${dateTime.hour}시 ${dateTime.minute}분 ${dateTime.second}초',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              Container(
                height: 70,
                padding: const EdgeInsets.all(16),
                child: const Text(
                  textAlign: TextAlign.start,
                  '한국어:',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(historyTranslatedText),
                  ),
                ),
              ),
              Container(
                height: 70,
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'English:',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(historyText),
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}
