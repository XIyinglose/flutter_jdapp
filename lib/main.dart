import 'package:flutter/material.dart';
import 'routes/Routes.dart';
void main() => runApp(MyApp());

/*
 *程序主入口
 */
class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/',  //初始化的时候加载的路由
        onGenerateRoute: onGenerateRoute, // 加载路由文件
    );
  }
}
