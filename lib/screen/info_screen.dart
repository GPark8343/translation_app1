import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

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
            child: Text.rich(
          TextSpan(
              style: TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
              //make link blue and underline
              text: "앱 사용 설명서 보기",
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  //on tap code here, you can navigate to other page or URL
                  String url = "https://blog.naver.com/genius8343/223055928351";
                  var urllaunchable = await canLaunch(
                      url); //canLaunch is from url_launcher package
                  if (urllaunchable) {
                    await launch(
                        url); //launch is from url_launcher package to launch URL
                  } else {}
                }),
        )));
  }
}
