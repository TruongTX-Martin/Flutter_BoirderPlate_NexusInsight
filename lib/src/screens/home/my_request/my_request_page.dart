import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_insight/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:inno_insight/src/blocs/blocs.dart';
import 'package:inno_insight/src/models/models.dart';
import 'package:inno_insight/src/screens/home/my_request/my_request_bloc.dart';
import 'package:inno_insight/src/screens/home/my_request/my_request_event.dart';
import 'package:inno_insight/src/utils/utils.dart';
import '../home.dart';
import 'my_request_state.dart';

class MyRequestPage extends StatefulWidget {
  @override
  _MyRequestPageState createState() => _MyRequestPageState();
}

class _MyRequestPageState extends State<MyRequestPage> {
  String currentCategory = MyRequestConstant.CATEGORY_ALL;
  String currentStatus = MyRequestConstant.STATUS_ALL;
  MyRequestBloc myRequestBloc;
  AuthenticationBloc authenticationBloc;

  //handle scroll to bottom listview
  final listviewScrollController = ScrollController();
  final listviewScrollThreshold = 200.0;

  //pull to refresh listview
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
    new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    myRequestBloc = BlocProvider.of<MyRequestBloc>(context);
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    this.fetchMyRequest();
    listviewScrollController.addListener(onScroll);
  }

  fetchMyRequest(){
    myRequestBloc.add(MyRequestEventFetch(category: convertCategory(), status: convertStatus()));
  }

  void onScroll() {
    final maxScroll = listviewScrollController.position.maxScrollExtent;
    final currentScroll = listviewScrollController.position.pixels;
    if (maxScroll - currentScroll <= listviewScrollThreshold) {
      myRequestBloc.add(MyRequestEventFetchMore(category: convertCategory(),status: convertStatus()));
    }
  }

  Future<bool> refreshListView() {
    myRequestBloc.add(MyRequestEventPullToRefresh(category: convertCategory(),status: convertStatus()));
    return Future.value();
  }

  String convertCategory(){
      if (currentCategory == MyRequestConstant.CATEGORY_ALL) {
        return '';
      } else if (currentCategory == MyRequestConstant.CATEGORY_OFFWORK) {
        return 'Off';
      } else {
        return  'Remote';
      }
  }

  String convertStatus(){
    switch (currentStatus) {
      case MyRequestConstant.STATUS_ALL:
            return '';
      case MyRequestConstant.STATUS_APPROVED:
            return MyRequestConstant.STATUS_APPROVED;
      case MyRequestConstant.STATUS_DISCARDED:
            return MyRequestConstant.STATUS_DISCARDED;
      case MyRequestConstant.STATUS_PENDDING:
            return MyRequestConstant.STATUS_PENDDING;
      case MyRequestConstant.STATUS_REJECTED:
            return MyRequestConstant.STATUS_REJECTED;
      default:
    }
  }

  handleLogout(){
    Utilities.showDialogWithCancel(
      context: context,
      title: 'Inno Insight',
      message: 'Are you sure want to logout?',
      onCancel: () {
        Navigator.of(context).pop();
      },
      onOk: () {
        Navigator.of(context).pop();
        authenticationBloc.add(LoggedOut());
      }
      );
  }

  @override
  Widget build(BuildContext context) {
    double width = Utilities.widthScreen(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('My Request')),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.outlined_flag), onPressed:() =>  this.handleLogout())
        ],
      ),
      body: BlocBuilder<MyRequestBloc, MyRequestState>(
        builder: (context, state) {
          return Stack(
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
                                    border:
                                        Border.all(color: HexColor('#6e6e6e')),
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
                                    border:
                                        Border.all(color: HexColor('#6e6e6e')),
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
              ),
              if (state is MyRequestStateLoading)
                Container(
                  child: Center(child: CircularProgressIndicator()),
                ),
              if (state is MyRequestStateLoaded)
                Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 50),
                        child: RefreshIndicator(
                          key: refreshIndicatorKey,
                          onRefresh: refreshListView,
                          child: ListView.builder(
                          controller: listviewScrollController,
                          itemCount: state.hasReachMax() ? state.listRequest.length : state.listRequest.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            return index >= state.listRequest.length ? BottomLoader() : MyRequestItemWidget(requestModel: state.listRequest[index]);
                          },
                        ),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  child: state is MyRequestStateLoaded && state.listRequest.length == 0 ?
                  Center(child: Text('No results found')) : null,
                )
            ],
          );
        },
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
                if(currentCategory != MyRequestConstant.CATEGORY_ALL){
                  setState(() {
                    currentCategory = MyRequestConstant.CATEGORY_ALL;
                    this.fetchMyRequest();
                  });
                }
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
                if(currentCategory != MyRequestConstant.CATEGORY_OFFWORK){
                  setState(() {
                    currentCategory = MyRequestConstant.CATEGORY_OFFWORK;
                    this.fetchMyRequest();
                  });
                }
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
                 if(currentCategory != MyRequestConstant.CATEGORY_REMOTE){
                  setState(() {
                    currentCategory = MyRequestConstant.CATEGORY_REMOTE;
                    this.fetchMyRequest();
                  });
                 }
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
                if(currentStatus !=  MyRequestConstant.STATUS_ALL){
                  setState(() {
                    currentStatus = MyRequestConstant.STATUS_ALL;
                  });
                  this.fetchMyRequest();
                }
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
                if(currentStatus !=  MyRequestConstant.STATUS_APPROVED){
                  setState(() {
                    currentStatus = MyRequestConstant.STATUS_APPROVED;
                  });
                  this.fetchMyRequest();
                }
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
                if(currentStatus !=  MyRequestConstant.STATUS_PENDDING){
                  setState(() {
                    currentStatus = MyRequestConstant.STATUS_PENDDING;
                  });
                  this.fetchMyRequest();
                }
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
                if(currentStatus !=  MyRequestConstant.STATUS_REJECTED){
                  setState(() {
                    currentStatus = MyRequestConstant.STATUS_REJECTED;
                  });
                  this.fetchMyRequest();
                }
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
                if(currentStatus !=  MyRequestConstant.STATUS_DISCARDED){
                  setState(() {
                    currentStatus = MyRequestConstant.STATUS_DISCARDED;
                  });
                  this.fetchMyRequest();
                }
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
                Navigator.pushNamed(context, Routes.add_request);
              },
            ),
            CupertinoActionSheetAction(
              child: Text(MyRequestConstant.REQUEST_OFFWORK,
                  style: TextStyle(color: HexColor('#3a7df6'))),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, Routes.add_request);
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

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}

class MyRequestItemWidget extends StatelessWidget {
  final RequestModel requestModel;

  const MyRequestItemWidget({Key key, @required this.requestModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Card(
          child: Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 3,
                              child: Text(
                                'Category',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                          Expanded(
                            flex: 4,
                            child: Container(
                              child: Text(requestModel.getCategory),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 3,
                              child: Text(
                                'Status',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          Expanded(
                            flex: 4,
                            child: Container(
                              child: Text(
                                requestModel.getStatus,
                                style: TextStyle(
                                    color: requestModel.getStatus ==
                                            'Approved'
                                        ? HexColor('#84ba62')
                                        : HexColor('#f4b775')),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 3,
                              child: Text(
                                'Compliance',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                          Expanded(
                            flex: 4,
                            child: Container(
                              child: Text(
                                requestModel.getCompliance,
                                style: TextStyle(
                                    color: requestModel
                                                .getCompliance ==
                                            'Passed'
                                        ? HexColor('#84ba62')
                                        : HexColor('#f4b775')),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 3,
                              child: Text(
                                'Requested Time',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                          Expanded(
                            flex: 4,
                            child: Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                requestModel.getRequestTime
                                    .getRequestTime,
                                style: TextStyle(
                                    color: requestModel
                                                .getCompliance ==
                                            'Passed'
                                        ? HexColor('#84ba62')
                                        : HexColor('#f4b775')),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 3,
                              child: Text(
                                'Submitted At',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                          Expanded(
                            flex: 4,
                            child: Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                requestModel.getSubmitAt
                                    .getSubmittedTime,
                                style: TextStyle(
                                    color: requestModel
                                                .getCompliance ==
                                            'Passed'
                                        ? HexColor('#84ba62')
                                        : HexColor('#f4b775')),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: new Container(
                alignment: Alignment.bottomRight,
                child: Image.asset(ImageSource.IMG_ARROW_RIGHT,
                    width: 15, height: 15),
              ),
            ),
          )
        ],
      )),
    );
  }
}
