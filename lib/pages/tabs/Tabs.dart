import 'package:flutter/material.dart';

import 'Cart.dart';
import 'Category.dart';
import 'HomePage.dart';
import 'User.dart';

/*
 * 底部导航栏页面
 */
class Tabs extends StatefulWidget {
  Tabs({Key key}) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _currentIndex = 0; //tab 的默认标记
  List appBarTitles = ['首页', '分类', '购物车', '我的'];
  PageController _pageController;

  List<Widget> _pageList = [HomePage(), CategoryPage(), CartPage(), UserPage()];

  @override
  void initState() { 
    super.initState();
    this._pageController=new PageController(initialPage:this._currentIndex );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("京东商城"),
      ),
      body: PageView(
         controller: this._pageController,
        children: this._pageList,
      ), //内容的切换,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this._currentIndex, //配置对应的索引值选中
        iconSize: 30.0, //icon的大小
        fixedColor: Colors.red, //选中的颜色
        type: BottomNavigationBarType.fixed, //配置底部tabs可以有多个按钮
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), title: getTabTitle(0)),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), title: getTabTitle(1)),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), title: getTabTitle(2)),
          BottomNavigationBarItem(
              icon: Icon(Icons.people), title: getTabTitle(3))
        ],
        onTap: (int index) {
          setState(() {
            //改变状态
            this._currentIndex = index;
             this._pageController.jumpToPage(index);
          });
        },
      ),
    );
  }

  /*
   * 获取bottomTab的颜色和文字
   */
  Text getTabTitle(int curIndex) {
    if (curIndex == _currentIndex) {
      return Text(appBarTitles[curIndex],
          style: TextStyle(fontSize: 14.0, color: Colors.red));
    } else {
      return Text(appBarTitles[curIndex],
          style: TextStyle(fontSize: 14.0, color: const Color(0xff515151)));
    }
  }
}
