import 'package:flutter/material.dart';
import 'package:flutter_jd/services/ScreenAdaper.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
    int _selectIndex=0;
  @override
  Widget build(BuildContext context) {

     //注意用ScreenAdaper必须得在build方法里面初始化
    ScreenAdaper.init(context);    

    //计算右侧GridView宽高比

    //左侧宽度
    
    var leftWidth=ScreenAdaper.getScreenWidth()/4;

    //右侧每一项宽度=（总宽度-左侧宽度-GridView外侧元素左右的Padding值-GridView中间的间距）/3

    var rightItemWidth=(ScreenAdaper.getScreenWidth()-leftWidth-20-20)/3;

    //获取计算后的宽度    
    rightItemWidth=ScreenAdaper.width(rightItemWidth);    
    //获取计算后的高度
    var rightItemHeight=rightItemWidth+ScreenAdaper.height(28);
    return Row(
      children: <Widget>[
      Container(         
          width: leftWidth,
          height: double.infinity,
          child: ListView.builder(
              itemCount: 28,
              itemBuilder: (context,index){
                return Column(
                  children: <Widget>[
                    InkWell(                      
                      onTap: (){
                          setState(() {
                            _selectIndex= index;
                          });
                      },
                      child: Container(                        
                          width: double.infinity,
                          height: ScreenAdaper.height(56),
                          child: Text("第$index条",textAlign: TextAlign.center),
                          color: _selectIndex==index?Colors.red:Colors.white,
                      ),
                    ),
                    Divider()
                  ],
                );
              },

          ),
        ),
         Expanded(
          flex: 1,
          child: Container(
              padding: EdgeInsets.all(10),
              height: double.infinity,
              color: Color.fromRGBO(240, 246, 246, 0.9),
              child: GridView.builder(

                gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(  // 设置网格布局
                  crossAxisCount:3, //每行3个
                  childAspectRatio: rightItemWidth/rightItemHeight,  // 宽高比例
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10
                ),
                itemCount: 18,
                itemBuilder: (context,index){
                    return Container(
                        // padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[

                            AspectRatio(
                              aspectRatio: 1/1,
                              child: Image.network("https://www.itying.com/images/flutter/list8.jpg",fit: BoxFit.cover),
                            ),
                            Container(
                              height: ScreenAdaper.height(28),
                              child: Text("女装"),
                            )
                          ],
                        ),
                    );
                },
              )
          ),
        )
      ],
    );
  }
}
