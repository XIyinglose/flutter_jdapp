import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);

  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>  with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return Text("我是用户组件");
  }
}