import 'package:flutter/material.dart';

class ProductContentThird extends StatefulWidget {
  ProductContentThird({Key key}) : super(key: key);

  @override
  _ProductContentThirdState createState() => _ProductContentThirdState();
}

class _ProductContentThirdState extends State<ProductContentThird> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Text("评论"),
    );
  }
}