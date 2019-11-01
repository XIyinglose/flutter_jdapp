import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jd/model/ProductContentModel.dart';
import '../../services/ScreenAdaper.dart';
import '../ProductContents/ProductContentFirst.dart';
import '../ProductContents/ProductContentSecond.dart';
import '../ProductContents/ProductContentThird.dart';
import '../../widget/JdButton.dart';
import '../../config/Config.dart';
import '../../widget/LoadingWidget.dart';

/*
  商品详情
 */
class ProductContent extends StatefulWidget {
  final Map arguments;
  ProductContent({Key key, this.arguments}) : super(key: key);

  @override
  _ProductContentState createState() => _ProductContentState();
}

class _ProductContentState extends State<ProductContent> {

  
  List _productContentList=[];

    @override
  void initState() {
    super.initState();
    // print(this._productContentData.sId);

    this._getContentData();
  }

    _getContentData() async{
    
    var api ='${Config.api}api/pcontent?id=${widget.arguments['id']}';

    print(api);
    var result = await Dio().get(api);
    var productContent = new ProductContentModel.fromJson(result.data);
  
    setState(() {
      this._productContentList.add(productContent.result);
    });
  }
  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: ScreenAdaper.width(400),
                child: TabBar(
                  indicatorColor: Colors.red,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: <Widget>[
                    Tab(
                      child: Text('商品'),
                    ),
                    Tab(
                      child: Text('详情'),
                    ),
                    Tab(
                      child: Text('评价'),
                    )
                  ],
                ),
              )
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () {
                showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                        ScreenAdaper.width(600), 76, 10, 0),
                    items: [
                      PopupMenuItem(
                        child: Row(
                          children: <Widget>[Icon(Icons.home), Text("首页")],
                        ),
                      ),
                      PopupMenuItem(
                        child: Row(
                          children: <Widget>[Icon(Icons.search), Text("搜索")],
                        ),
                      )
                    ]);
              },
            )
          ],
        ),
        body: this._productContentList.length>0?Stack(

          children: <Widget>[

            TabBarView(
                children: <Widget>[
                  ProductContentFirst(this._productContentList),
                  ProductContentSecond(this._productContentList),
                  ProductContentThird()
                ],
             ),
             Positioned(
               width: ScreenAdaper.width(750),
               height: ScreenAdaper.width(120),
               bottom: 0,
               child: Container(               
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.black26,
                      width: 1
                    )
                  ),
                  color: Colors.white
                ),
                child: Row(
                  children: <Widget>[

                    Container(
                      padding: EdgeInsets.only(top:ScreenAdaper.height(10)),
                      width: 100,
                      height: ScreenAdaper.height(120),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.shopping_cart),
                          Text("购物车")
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: JdButton(
                        color:Color.fromRGBO(253, 1, 0, 0.9),
                        text: "加入购物车",
                        cb: (){
                          print('加入购物车');
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: JdButton(
                        color: Color.fromRGBO(255, 165, 0, 0.9),
                        text: "立即购买",
                        cb: (){
                          print('立即购买');
                        },
                      ),
                    )

                  ],
                ),
               ),
             )
          ],
        ):LoadingWidget(),
      ),
    );
  }
}
