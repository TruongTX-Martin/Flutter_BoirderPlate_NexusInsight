import 'package:flutter/material.dart';

class AddRequestView extends StatefulWidget {
  @override
  _AddRequestViewState createState() => _AddRequestViewState();
}

class _AddRequestViewState extends State<AddRequestView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offwork request'),
      ),
      body: Text('Offwork text'),
    );
  }
}