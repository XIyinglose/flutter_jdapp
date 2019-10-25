import 'package:flutter/material.dart';
import 'package:flutter_jd/pages/tabs/Tabs.dart';


/*
 * 路由配置文件
 */

//配置路由
 final routes = {
    '/':(context)=>Tabs(),  // 首页

 };

 //固定写法, 命名路由传值
var onGenerateRoute=(RouteSettings settings) {
      // 统一处理
      final String name = settings.name; 
      final Function pageContentBuilder = routes[name];
      if (pageContentBuilder != null) {
        if (settings.arguments != null) {
          final Route route = MaterialPageRoute(
              builder: (context) =>
                  pageContentBuilder(context, arguments: settings.arguments));
          return route;
        }else{
            final Route route = MaterialPageRoute(
              builder: (context) =>
                  pageContentBuilder(context));
            return route;
        }
      }
};