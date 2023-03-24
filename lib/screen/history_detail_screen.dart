import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:translation_app/provider/history_manage.dart';

class HistoryDetailSscreen extends StatefulWidget {
  static const routeName = '/history-detail';

  @override
  State<HistoryDetailSscreen> createState() => _HistoryDetailSscreenState();
}

class _HistoryDetailSscreenState extends State<HistoryDetailSscreen> {
  final _titleController = TextEditingController();

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
        appBar: AppBar(
          title: Text('${historyTitle}'),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx1) {
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
                                Provider.of<HistoryManage>(context,
                                        listen: false)
                                    .deleteHistories(historyId);
                                await Provider.of<HistoryManage>(context,
                                        listen: false)
                                    .fetchAndSetHistories();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();

                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        content: SingleChildScrollView(
                                          child: Text('삭제가 완료되었습니다.'),
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
                icon: Icon(Icons.delete)),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx2) {
                        return SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width /
                                    360 *
                                    100.0),
                            child: AlertDialog(
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SingleChildScrollView(
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width /
                                              360 *
                                              10.0),
                                      child: Column(
                                        children: [
                                          Text('제목 수정'),
                                          TextFormField(
                                            controller: _titleController,
                                            decoration: InputDecoration(
                                                hintText: historyTitle),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                360 *
                                                10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              actions: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.black),
                                  onPressed: () async {
                                    if (_titleController.text.isEmpty) {
                                      // 빈 스토리는 작성 못하게 해야 함
                                      return;
                                    }
                                    var findedHistory =
                                        await Provider.of<HistoryManage>(
                                                context,
                                                listen: false)
                                            .findById(historyId);
                                    await Provider.of<HistoryManage>(context,
                                            listen: false)
                                        .changeTitle(findedHistory,
                                            _titleController.text);
                                    await Provider.of<HistoryManage>(context,
                                            listen: false)
                                        .fetchAndSetHistories();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    setState(() {});
                                  },
                                  icon: Icon(Icons.check),
                                  label: Text('제목 바꾸기'),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },
                icon: Icon(Icons.edit)),
          ],
        ),
        body: SafeArea(
            child: Center(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.width / 360 * 70,
                padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width / 360 * 16),
                child: Text(
                  textAlign: TextAlign.start,
                  '${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일 ${dateTime.hour}시 ${dateTime.minute}분 ${dateTime.second}초',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 360 * 20.0),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.width / 360 * 70,
                padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width / 360 * 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      textAlign: TextAlign.start,
                      '한국어:',
                      style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width / 360 * 20.0),
                    ),
                    IconButton(
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: historyTranslatedText));
                        },
                        icon: Icon(Icons.copy))
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: SelectableText(
                        historyTranslatedText,
                        cursorColor: Colors.yellow,
                        showCursor: true,
                        toolbarOptions: ToolbarOptions(
                            copy: true,
                            selectAll: true,
                            cut: false,
                            paste: false),
                      )),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.width/360*70,
                padding: EdgeInsets.all(MediaQuery.of(context).size.width/360*16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text(
                      'English:',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: MediaQuery.of(context).size.width/360*20.0),
                    ),
                    IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: historyText));
                        },
                        icon: Icon(Icons.copy))
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: SelectableText(
                      historyText,
                      cursorColor: Colors.yellow,
                      showCursor: true,
                      toolbarOptions: ToolbarOptions(
                          copy: true,
                          selectAll: true,
                          cut: false,
                          paste: false),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}