import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jd/services/ScreenAdaper.dart';
import '../../config/Config.dart';
import '../../model/CateModel.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with AutomaticKeepAliveClientMixin {
  int _selectIndex = 0;
  List _leftCateList = [];
  List _rightCateList = [];

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    _getLeftCateData();
  }

  // 左侧数据列表
  _getLeftCateData() async {
    var api = '${Config.api}api/pcate';
    var result = await Dio().get(api);
    var leftCateList = CateModel.fromJson(result.data);
    setState(() {
      this._leftCateList = leftCateList.result;
    });
    _getrightCateData(leftCateList.result[0].sId);
  }

  // 右侧数据

  _getrightCateData(pid) async {
    var api = '${Config.api}api/pcate?pid=$pid';
    var result = await Dio().get(api);
    var rightCateList = new CateModel.fromJson(result.data);

    setState(() {
      this._rightCateList = rightCateList.result;
    });
  }

  // 左侧列表

  Widget _leftCateWidget(leftWidth) {
    if (this._leftCateList.length > 0) {
      return Container(
        width: leftWidth,
        height: double.infinity,
        child: ListView.builder(
          itemCount: this._leftCateList.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectIndex = index;
                      this._getrightCateData(
                          this._leftCateList[index].sId); // 请求右侧数据列表
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: ScreenAdaper.height(90),
                    padding: EdgeInsets.only(top: ScreenAdaper.height(24)),
                    child: Text("${this._leftCateList[index].title}",
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center),
                    color: _selectIndex == index
                        ? Color.fromRGBO(240, 246, 246, 0.9)
                        : Colors.white,
                  ),
                ),
                Divider(
                  height: 1,
                )
              ],
            );
          },
        ),
      );
    } else {
      return Container(width: leftWidth, height: double.infinity);
    }
  }

  // 右侧列表

  Widget _rightCateWidget(rightItemWidth, rightItemHeight) {
    if (this._rightCateList.length > 0) {
      return Expanded(
        flex: 1,
        child: Container(
            padding: EdgeInsets.all(10),
            height: double.infinity,
            color: Color.fromRGBO(240, 246, 246, 0.9),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  // 设置网格布局
                  crossAxisCount: 3, //每行3个
                  childAspectRatio: rightItemWidth / rightItemHeight, // 宽高比例
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemCount: this._rightCateList.length,
              itemBuilder: (context, index) {
                //处理图片
                String pic = this._rightCateList[index].pic;
                pic = Config.api + pic.replaceAll('\\', '/');
                return Container(
                 padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Image.network("$pic", fit: BoxFit.cover),
                      ),
                      Container(
                        height: ScreenAdaper.height(40),
                        child: Text("${this._rightCateList[index].title}",style: TextStyle(fontSize: 12),),
                      )
                    ],
                  ),
                );
              },
            )),
      );
    } else {
      return Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(10),
            height: double.infinity,
            color: Color.fromRGBO(240, 246, 246, 0.9),
            child: Text("加载中..."),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    //注意用ScreenAdaper必须得在build方法里面初始化
    ScreenAdaper.init(context);

    //计算右侧GridView宽高比

    //左侧宽度

    var leftWidth = ScreenAdaper.getScreenWidth() / 4;

    //右侧每一项宽度=（总宽度-左侧宽度-GridView外侧元素左右的Padding值-GridView中间的间距）/3

    var rightItemWidth =
        (ScreenAdaper.getScreenWidth() - leftWidth - 20 - 20) / 3;

    //获取计算后的宽度
    rightItemWidth = ScreenAdaper.width(rightItemWidth);
    //获取计算后的高度
    var rightItemHeight = rightItemWidth + ScreenAdaper.height(28);
    return Row(
      children: <Widget>[
        _leftCateWidget(leftWidth),
        _rightCateWidget(rightItemWidth, rightItemHeight),
      ],
    );
  }
}
