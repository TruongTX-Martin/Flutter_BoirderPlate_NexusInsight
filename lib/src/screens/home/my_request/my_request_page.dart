import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inno_insight/src/utils/utils.dart';
import '../home.dart';

class MyRequestPage extends StatefulWidget {
  @override
  _MyRequestPageState createState() => _MyRequestPageState();
}

class _MyRequestPageState extends State<MyRequestPage> {
  String currentCategory = MyRequestConstant.CATEGORY_ALL;
  String currentStatus = MyRequestConstant.STATUS_ALL;

  @override
  Widget build(BuildContext context) {
    double width = Utilities.widthScreen(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('My Request')),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: GestureDetector(
                          onTap: () {
                            this.showActionSheetCategory();
                          },
                          child: Container(
                            width: width / 2 - 30,
                            decoration: BoxDecoration(
                                border: Border.all(color: HexColor('#6e6e6e')),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(currentCategory),
                                  Image.asset(ImageSource.IMG_DROPDOWN,
                                      width: 15, height: 15)
                                ],
                              ),
                            ),
                          ),
                        )),
                    Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: GestureDetector(
                          onTap: () {
                            this.showActionSheetStatus();
                          },
                          child: Container(
                            width: width / 2 - 30,
                            decoration: BoxDecoration(
                                border: Border.all(color: HexColor('#6e6e6e')),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(currentStatus),
                                  Image.asset(ImageSource.IMG_DROPDOWN,
                                      width: 15, height: 15)
                                ],
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              )
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          this.showActionSheetRequest();
        },
      ),
    );
  }

  Future<void> showActionSheetCategory() async {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text('Choose category'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text(MyRequestConstant.CATEGORY_ALL,
                  style: TextStyle(
                      color: currentCategory == MyRequestConstant.CATEGORY_ALL
                          ? Colors.red
                          : HexColor('#3a7df6'))),
              onPressed: () {
                setState(() {
                  currentCategory = MyRequestConstant.CATEGORY_ALL;
                });
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: Text(MyRequestConstant.CATEGORY_OFFWORK,
                  style: TextStyle(
                      color:
                          currentCategory == MyRequestConstant.CATEGORY_OFFWORK
                              ? Colors.red
                              : HexColor('#3a7df6'))),
              onPressed: () {
                setState(() {
                  currentCategory = MyRequestConstant.CATEGORY_OFFWORK;
                });
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: Text(MyRequestConstant.CATEGORY_REMOTE,
                  style: TextStyle(
                      color:
                          currentCategory == MyRequestConstant.CATEGORY_REMOTE
                              ? Colors.red
                              : HexColor('#3a7df6'))),
              onPressed: () {
                setState(() {
                  currentCategory = MyRequestConstant.CATEGORY_REMOTE;
                });
                Navigator.pop(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            child: Text(MyRequestConstant.CANCEL),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  Future<void> showActionSheetStatus() async {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text('Choose status'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text(MyRequestConstant.STATUS_ALL,
                  style: TextStyle(
                      color: currentStatus == MyRequestConstant.STATUS_ALL
                          ? Colors.red
                          : HexColor('#3a7df6'))),
              onPressed: () {
                setState(() {
                  currentStatus = MyRequestConstant.STATUS_ALL;
                });
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: Text(MyRequestConstant.STATUS_APPROVED,
                  style: TextStyle(
                      color: currentStatus == MyRequestConstant.STATUS_APPROVED
                          ? Colors.red
                          : HexColor('#3a7df6'))),
              onPressed: () {
                setState(() {
                  currentStatus = MyRequestConstant.STATUS_APPROVED;
                });
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: Text(MyRequestConstant.STATUS_PENDDING,
                  style: TextStyle(
                      color: currentStatus == MyRequestConstant.STATUS_PENDDING
                          ? Colors.red
                          : HexColor('#3a7df6'))),
              onPressed: () {
                setState(() {
                  currentStatus = MyRequestConstant.STATUS_PENDDING;
                });
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: Text(MyRequestConstant.STATUS_REJECTED,
                  style: TextStyle(
                      color: currentStatus == MyRequestConstant.STATUS_REJECTED
                          ? Colors.red
                          : HexColor('#3a7df6'))),
              onPressed: () {
                setState(() {
                  currentStatus = MyRequestConstant.STATUS_REJECTED;
                });
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: Text(MyRequestConstant.STATUS_DISCARDED,
                  style: TextStyle(
                      color: currentStatus == MyRequestConstant.STATUS_DISCARDED
                          ? Colors.red
                          : HexColor('#3a7df6'))),
              onPressed: () {
                setState(() {
                  currentStatus = MyRequestConstant.STATUS_DISCARDED;
                });
                Navigator.pop(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            child: Text(MyRequestConstant.CANCEL),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  Future<void> showActionSheetRequest() async {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text('Choose actions'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text(MyRequestConstant.REQUEST_REMOTE,
                  style: TextStyle(color: HexColor('#3a7df6'))),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: Text(MyRequestConstant.REQUEST_OFFWORK,
                  style: TextStyle(color: HexColor('#3a7df6'))),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            child: Text(MyRequestConstant.CANCEL),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
