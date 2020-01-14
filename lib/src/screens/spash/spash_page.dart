import 'package:flutter/material.dart';
import 'package:inno_insight/src/utils/utils.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Material(
      child: Image.asset(ImageSource.IMG_LOGO, width: 200, height: 63),
    );
  }
}
