import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../services/ScreenAdaper.dart';
import '../../config/Config.dart';
import '../../model/ProductModel.dart';
import '../../widget/LoadingWidget.dart';
/*
 *商品搜索 
 */
class ProductListPage extends StatefulWidget {
  Map arguments;
  ProductListPage({Key key, this.arguments}) : super(key: key);

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {

 //Scaffold key
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //用于上拉分页
  ScrollController _scrollController = ScrollController(); //listview 的控制器
  //分页
  int _page = 1;

  //每页有多少条数据
  int _pageSize=8;

  //数据
  List _productList = [];
  /*
  排序:价格升序 sort=price_1 价格降序 sort=price_-1  销量升序 sort=salecount_1 销量降序 sort=salecount_-1
  */
  String _sort = "";

  //解决重复请求的问题
  bool flag=true;

  //是否有数据

  bool _hasMore=true;

    @override
    void initState() { 
      super.initState();
      _getProductListData();
      //监听滚动条滚动事件
    _scrollController.addListener((){
        //_scrollController.position.pixels //获取滚动条滚动的高度
        //_scrollController.position.maxScrollExtent  //获取页面高度 
        if(_scrollController.position.pixels>_scrollController.position.maxScrollExtent-20){
          if(this.flag && this._hasMore){
            _getProductListData();
          }
        }
    });
    }


  // 获取商品列表数据
  _getProductListData() async{
    setState(() {
     this.flag=false; 
    });
          var api =
        '${Config.api}api/plist?cid=${widget.arguments["cid"]}&page=${this._page}&sort=${this._sort}&pageSize=${this._pageSize}';

         var result = await Dio().get(api);
        print(""+widget.arguments["cid"]);
            print(api);
    var productList = new ProductModel.fromJson(result.data);
     if(productList.result.length<this._pageSize){
       setState(() {
        // this._productList = productList.result;
        this._productList.addAll(productList.result);
        this._hasMore=false;
        this.flag=true; 
      });

    }else{
       setState(() {
        // this._productList = productList.result;
        this._productList.addAll(productList.result);
        this._page++;
        this.flag=true; 
      });

    }
  }

  //显示加载中的圈圈
  Widget _showMore(index){

    if(this._hasMore){
        return (index==this._productList.length-1)?LoadingWidget():Text("");
    }else{
       return (index==this._productList.length-1)?Text("--我是有底线的--"):Text("");;
    }
  }
 
  //商品列表
  Widget _productListWidget() {
    if(this._productList.length >0){
      return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: ScreenAdaper.height(80)),
      child: ListView.builder(
        itemBuilder: (context, index) {
           //处理图片
            String pic=this._productList[index].pic;
            pic=Config.api+pic.replaceAll('\\', '/');
          return Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: ScreenAdaper.width(180),
                    height: ScreenAdaper.height(180),
                    child: Image.network(
                       "$pic",
                        fit: BoxFit.cover),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: ScreenAdaper.height(180),
                      margin: EdgeInsets.only(left: 10),
                      // color: Colors.red,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                             "${this._productList[index].title}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                          Row(
                            children: <Widget>[
                              Container(
                                height: ScreenAdaper.height(36),
                                margin: EdgeInsets.only(right: 10),
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),

                                //注意 如果Container里面加上decoration属性，这个时候color属性必须得放在BoxDecoration
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromRGBO(230, 230, 230, 0.9),
                                ),

                                child: Text("4g"),
                              ),
                              Container(
                                height: ScreenAdaper.height(36),
                                margin: EdgeInsets.only(right: 10),
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromRGBO(230, 230, 230, 0.9),
                                ),
                                child: Text("126"),
                              ),
                            ],
                          ),
                          Text(
                             "¥${this._productList[index].price}",
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Divider(height: 20)
            ],
          );
        },
        itemCount: this._productList.length,
      ),
    );
    }else{
      //加载中
      return LoadingWidget();
    }
  }
 
 
  //筛选导航
  Widget _subHeaderWidget() {
    return Positioned(
      top: 0,
      height: ScreenAdaper.height(80),
      width: ScreenAdaper.width(750),
      child: Container(
        width: ScreenAdaper.width(750),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1, color: Color.fromRGBO(233, 233, 233, 0.9)))),
        height: ScreenAdaper.height(80),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: InkWell(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, ScreenAdaper.height(16), 0, ScreenAdaper.height(16)),
                  child: Text(
                    "综合",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                onTap: () {
                  // 点击事件
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, ScreenAdaper.height(16), 0, ScreenAdaper.height(16)),
                  child: Text("销量", textAlign: TextAlign.center),
                ),
                onTap: () {},
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, ScreenAdaper.height(16), 0, ScreenAdaper.height(16)),
                  child: Text("价格", textAlign: TextAlign.center),
                ),
                onTap: () {},
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, ScreenAdaper.height(16), 0, ScreenAdaper.height(16)),
                  child: Text("筛选", textAlign: TextAlign.center),
                ),
                onTap: () {
                   _scaffoldKey.currentState.openEndDrawer();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("商品列表"),
          // leading: Text(""),
          actions: <Widget>[Text("")],
        ),
        endDrawer: Drawer(
          child: Container(
            child: Text("实现筛选功能"),
          ),
        ),
        body: Stack(
          children: <Widget>[
            _productListWidget(),
            _subHeaderWidget(),
          ],
        ));
  }
}
