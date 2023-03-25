import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  static const routeName = '/info';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text('앱 사용 설명서'),
      ),
      body: Center(
          child: Text(
              '먼저 api key랑 json을 등록해야 합니다.\n\n\n\napi key랑 json을 다시 설정하고 싶다면 api 등록 화면에서 설정 완료라 써져있는 박스를 꾹 누르시면 삭제 여부를 묻는 버튼이 나오고 거기서 삭제하기 버튼을 누르시면 됩니다.\n\n\n\n녹음은 연속으로 5분(300초) 간격으로 끊기며 자동으로 저장되며 다시 녹음이 시작됩니다.')),
    );
  }
}
