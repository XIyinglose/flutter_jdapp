import 'package:flutter/material.dart';
import '../services/ScreenAdaper.dart';
import '../services/SearchServices.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var _keywords;

  List _historyListData = []; //历史记录

  @override
  void initState() {
    super.initState();
    this._getHistoryData();
  }

  _getHistoryData() async {
    var _historyListData = await SearchServices.getHistoryList();
    setState(() {
      this._historyListData = _historyListData;
    });
  }

  _showAlertDialog(keywords) async {
    var result = await showDialog(
        barrierDismissible: false, //表示点击灰色背景的时候是否消失弹出框
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("提示信息!"),
            content: Text("您确定要删除吗?"),
            actions: <Widget>[
              FlatButton(
                child: Text("取消"),
                onPressed: () {
                  print("取消");
                  Navigator.pop(context, 'Cancle');
                },
              ),
              FlatButton(
                child: Text("确定"),
                onPressed: () async {
                  //注意异步
                  await SearchServices.removeHistoryData(keywords);
                  this._getHistoryData();
                  Navigator.pop(context, "Ok");
                },
              )
            ],
          );
        });
  }

  Widget _historyListWidget() {
    if (_historyListData.length > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text("历史记录", style: Theme.of(context).textTheme.title),
          ),
          Divider(),
          Column(
            children: this._historyListData.map((value) {
              return Column(
                children: <Widget>[
                  ListTile(
                    title: Text("${value}"),
                    onLongPress: () {
                      this._showAlertDialog("${value}");
                    },
                  ),
                  Divider()
                ],
              );
            }).toList(),
          ),
          SizedBox(height: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  SearchServices.clearHistoryList();
                  this._getHistoryData();
                },
                child: Container(
                  width: ScreenAdaper.width(400),
                  height: ScreenAdaper.height(64),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black45, width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[Icon(Icons.delete), Text("清空历史记录")],
                  ),
                ),
              )
            ],
          )
        ],
      );
    } else {
      return Text("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none)),
              onChanged: (value) {
                this._keywords = value;
              },
            ),
            height: ScreenAdaper.height(68),
            decoration: BoxDecoration(
                color: Color.fromRGBO(233, 233, 233, 0.8),
                borderRadius: BorderRadius.circular(30)),
          ),
          actions: <Widget>[
            InkWell(
              child: Container(
                height: ScreenAdaper.height(68),
                width: ScreenAdaper.width(80),
                child: Row(
                  children: <Widget>[Text("搜索")],
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/productList',
                    arguments: {"keywords": this._keywords});

                //保存搜索历史数据
                SearchServices.setHistoryData(this._keywords);
              },
            )
          ],
        ),
        //历史记录
        body: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Container(
                child: Text("热搜", style: Theme.of(context).textTheme.title),
              ),
              Divider(),
              Wrap(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(233, 233, 233, 0.9),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text("女装"),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(233, 233, 233, 0.9),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text("女装"),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(233, 233, 233, 0.9),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text("笔记本电脑"),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(233, 233, 233, 0.9),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text("女装111"),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(233, 233, 233, 0.9),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text("女装"),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(233, 233, 233, 0.9),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text("女装"),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(233, 233, 233, 0.9),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text("女装"),
                  )
                ],
              ),
              SizedBox(height: 10),
              //历史记录
              _historyListWidget()
            ],
          ),
        ));
  }
}
