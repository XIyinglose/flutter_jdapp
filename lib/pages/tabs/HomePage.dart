import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jd/model/ProductModel.dart';
import 'package:flutter_jd/services/ScreenAdaper.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../../config/Config.dart';

//轮播图类模型
import '../../model/FocusModel.dart';
/*
 * 首页 
 */

class HomePage extends StatefulWidget   {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  List _focusData = []; //轮播图数据集合
  List _hotProductList = []; //产品分类
   List _bestProductList = [];

  @override
  bool get wantKeepAlive => true;
/*
 *网络请求数据 
 */
  @override
  void initState() {
    super.initState();
    _showSwiperData();
    _getHotProductData();
    _getBestProductData();
  }

  //获取轮播图数据
  _showSwiperData() async {
    var api = '${Config.api}api/focus'; // 接口
    var result = await Dio().get(api);
    var focusList = FocusModel.fromJson(result.data);
  
    setState(() {
      this._focusData = focusList.result;
    });
  }

    //热门商品数据
  _getHotProductData() async {
    var api = '${Config.api}api/plist?is_hot=1';
    var result = await Dio().get(api);
    var hotProductList = ProductModel.fromJson(result.data);
      print("------>" + result.toString());
    setState(() {
      this._hotProductList = hotProductList.result;
    });
  }

   //获取热门推荐的数据
  _getBestProductData() async {
    var api = '${Config.api}api/plist?is_best=1';
    var result = await Dio().get(api);
    var bestProductList = ProductModel.fromJson(result.data);    
    setState(() {
      this._bestProductList = bestProductList.result;
    });
  }


  //轮播图组件
  Widget _swiperWidget() {
    if (this._focusData.length > 0) {
      return Container(
        child: AspectRatio(
          aspectRatio: 2 / 1,
          child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                String pic = this._focusData[index].pic;
                pic = Config.api + pic.replaceAll('\\', '/'); // 把 \ 转成/ 的形式
                return new Image.network(
                  "$pic",
                  fit: BoxFit.fill,
                );
              },
              itemCount: this._focusData.length, //轮播图 个数
              pagination: new SwiperPagination(), // 底部的圆点
              autoplay: true), // 自动播放
        ),
      );
    } else {
      return Text('加载中...');
    }
  }

    Widget _titleWidget(value) {
    return Container(
      height: ScreenAdaper.height(32),
      margin: EdgeInsets.only(left: ScreenAdaper.width(20)),
      padding: EdgeInsets.only(left: ScreenAdaper.width(20)),
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
        color: Colors.red,
        width: ScreenAdaper.width(10),
      ))),
      child: Text(
        value,
        style: TextStyle(color: Colors.black54),
      ),
    );
  }

  //热门商品 控件
  Widget _hotProductListWidget() {
   if (this._hotProductList.length > 0) {
      return Container(
        height: ScreenAdaper.height(234),
        padding: EdgeInsets.all(ScreenAdaper.width(20)),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (contxt, index) {
            //处理图片
            String sPic = this._hotProductList[index].pic;
            sPic = Config.api + sPic.replaceAll('\\', '/');

            return Column(
              children: <Widget>[
                Container(
                  height: ScreenAdaper.height(140),
                  width: ScreenAdaper.width(140),
                  margin: EdgeInsets.only(right: ScreenAdaper.width(21)),
                  child: Image.network(sPic, fit: BoxFit.cover),
                ),
                Container(
                  padding: EdgeInsets.only(top: ScreenAdaper.height(10)),
                  height: ScreenAdaper.height(44),
                  child: Text(
                    "¥${this._hotProductList[index].price}",
                    style: TextStyle(color: Colors.red),
                  ),
                )
              ],
            );
          },
          itemCount: this._hotProductList.length,
        ),
      );
    } else {
      return Text("");
    }
  }
  //推荐商品
  Widget _recProductListWidget(){
      var itemWidth = (ScreenAdaper.getScreenWidth() - 30) / 2; 
return  Container(
  padding: EdgeInsets.all(10),
  child: Wrap(
    runSpacing: 10 ,
    spacing: 10,
    children: this._bestProductList.map((value) {
         //图片
          String sPic=value.sPic;
          sPic=Config.api+sPic.replaceAll('\\', '/');

          return Container(
            padding: EdgeInsets.all(10),
            width: itemWidth,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromRGBO(233, 233, 233, 0.9), width: 1)),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: AspectRatio(
                    //防止服务器返回的图片大小不一致导致高度不一致问题
                    aspectRatio: 1 / 1,
                    child: Image.network(
                      "$sPic",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: ScreenAdaper.height(20)),
                  child: Text(
                    "${value.title}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: ScreenAdaper.height(20)),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "¥${value.price}",
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text( "¥${value.oldPrice}",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough)),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
      }).toList(),
  ),
);

  }

  @override
  Widget build(BuildContext context) {
    //这屏幕适配的初始化, 要加上去
     ScreenAdaper.init(context);
    return ListView(
      children: <Widget>[
           _swiperWidget(),
        SizedBox(height: ScreenAdaper.height(20)),
        _titleWidget("猜你喜欢"),
        SizedBox(height: ScreenAdaper.height(20)),
        _hotProductListWidget(),
         _titleWidget("热门推荐"),
          _recProductListWidget()
      ],
    );
  }
}
