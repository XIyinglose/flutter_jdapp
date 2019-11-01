import 'package:flutter/material.dart';

class ProductContentFirst extends StatefulWidget {
  ProductContentFirst({Key key}) : super(key: key);

  _ProductContentFirstState createState() => _ProductContentFirstState();
}

class _ProductContentFirstState extends State<ProductContentFirst> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Text("商品页面"),
    );
  }
}