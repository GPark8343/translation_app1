import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translation_app/provider/api_manage.dart';

class SetApiScreen extends StatefulWidget {
  static const routeName = '/set-api';
  final Function? selectPage;
  SetApiScreen({this.selectPage});

  @override
  State<SetApiScreen> createState() => _SetApiScreenState();
}

class _SetApiScreenState extends State<SetApiScreen> {
  final _priceFocusNode = FocusNode();
  final _jsonFocusNode = FocusNode();
  final _keyController = TextEditingController();
  final _jsonController = TextEditingController();

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _jsonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: []),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('setting'),
                Text('api key를 입력하세요'),
                TextFormField(
                  controller: _keyController,
                  decoration: InputDecoration(labelText: 'api key'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 360 * 10,
                ),
                TextFormField(
                  controller: _jsonController,
                  decoration: InputDecoration(labelText: 'json'),
                  keyboardType: TextInputType.multiline,
                  focusNode: _jsonFocusNode,
                ),
                SizedBox(height:MediaQuery.of(context).size.width/360* 100,),
                TextButton(
                    onPressed: () async {
                      if (_keyController.text.isEmpty ||
                          _jsonController.text.isEmpty) {
                        // 빈 필드는 작성 못하게 해야 함
                        return;
                      }
                      await Provider.of<ApiManage>(context, listen: false)
                          .addApi(_keyController.text, _jsonController.text);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      widget.selectPage!(1);
                      await Provider.of<ApiManage>(context, listen: false)
                          .fetchAndSetApi();
                    },
                    child: Text('입력 완료'))
              ],
            ),
          ),
        ));
  }
}
