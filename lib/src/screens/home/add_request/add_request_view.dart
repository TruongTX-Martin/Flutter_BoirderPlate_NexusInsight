import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_insight/src/screens/home/my_request/my_request_page.dart';
import 'package:intl/intl.dart';
import 'add_request.dart';
import 'package:inno_insight/src/utils/utils.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';

class DateRequest {
  DateTime dateTime;
  bool hasMorning;
  bool hasAfternoon;

  DateRequest(DateTime dateTime, bool morning, bool afternoon) {
    this.dateTime = dateTime;
    this.hasMorning = morning;
    this.hasAfternoon = afternoon;
  }
}

class AddRequestView extends StatefulWidget {
  RequestType requestType;

  AddRequestView(RequestType requestType){
    this.requestType = requestType;
  }

  DateFormat dateFormat = new DateFormat('dd/MM/yyyy');
  @override
  _AddRequestViewState createState() => _AddRequestViewState();
}

DateTime getInitDateFrom() {
  if (DateTime.now().weekday == DateTime.saturday) {
    return DateTime.now().add(Duration(days: 2));
  }
  if (DateTime.now().weekday == DateTime.sunday) {
    return DateTime.now().add(Duration(days: 1));
  }
  return DateTime.now();
}

class _AddRequestViewState extends State<AddRequestView> {
  DateTime dateFrom = getInitDateFrom();
  DateTime dateTo = getInitDateFrom();
  List<DateRequest> list = new List();
  TextEditingController controllerReason = new TextEditingController();
  TextEditingController controllerBackupPlan = new TextEditingController();
  bool showAlertReason = false;
  bool showAlertBackup = false;

  AddRequestBloc addRequestBloc;

  @override
  void initState() {
    super.initState();
    getArrayDateRequest(dateFrom, dateTo);
    addRequestBloc = BlocProvider.of<AddRequestBloc>(context);
  }

  bool canSelectedDateFrom(DateTime dateTime) {
    if (dateTime.isAfter(DateTime.now()) &&
        (dateTime.weekday != DateTime.saturday &&
            dateTime.weekday != DateTime.sunday)) {
      return true;
    }
    return false;
  }

  bool canSelectedDateTo(DateTime dateTime) {
    if (dateTime.isAfter(dateFrom.subtract(Duration(days: 1))) &&
        (dateTime.weekday != DateTime.saturday &&
            dateTime.weekday != DateTime.sunday)) {
      return true;
    }
    return false;
  }

  void showDatePickerFrom(BuildContext context) async {
    DateTime newDateTime = await showRoundedDatePicker(
        context: context,
        initialDate: dateFrom,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 1),
        borderRadius: 16,
        onTapDay: (DateTime dateTime, bool available) {
          return canSelectedDateFrom(dateTime);
        },
        builderDay: (DateTime dateTime, bool isCurrentDay, bool isSelected,
            TextStyle defaultTextStyle) {
          if (isSelected) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.orange[600], shape: BoxShape.circle),
              child: Center(
                child: Text(
                  dateTime.day.toString(),
                  style: defaultTextStyle,
                ),
              ),
            );
          }
          if (!canSelectedDateFrom(dateTime)) {
            return Container(
              child: Center(
                child: Text(
                  dateTime.day.toString(),
                  style: TextStyle(color: HexColor('#CACACA')),
                ),
              ),
            );
          }
          return Container(
            child: Center(
              child: Text(
                dateTime.day.toString(),
                style: defaultTextStyle,
              ),
            ),
          );
        });
    if (newDateTime != null) {
      setState(() {
        dateFrom = newDateTime;
      });
      if (newDateTime.isAfter(dateTo)) {
        dateTo = newDateTime;
      }
      getArrayDateRequest(dateFrom, dateTo);
    }
  }

  void showDatePickerTo(BuildContext context) async {
    DateTime newDateTime = await showRoundedDatePicker(
        context: context,
        initialDate: dateTo,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 1),
        borderRadius: 16,
        onTapDay: (DateTime dateTime, bool available) {
          return canSelectedDateTo(dateTime);
        },
        builderDay: (DateTime dateTime, bool isCurrentDay, bool isSelected,
            TextStyle defaultTextStyle) {
          if (isSelected) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.orange[600], shape: BoxShape.circle),
              child: Center(
                child: Text(
                  dateTime.day.toString(),
                  style: defaultTextStyle,
                ),
              ),
            );
          }
          if (!canSelectedDateTo(dateTime)) {
            return Container(
              child: Center(
                child: Text(
                  dateTime.day.toString(),
                  style: TextStyle(color: HexColor('#CACACA')),
                ),
              ),
            );
          }
          return Container(
            child: Center(
              child: Text(
                dateTime.day.toString(),
                style: defaultTextStyle,
              ),
            ),
          );
        });
    if (newDateTime != null) {
      setState(() {
        dateTo = newDateTime;
      });
      getArrayDateRequest(dateFrom, dateTo);
    }
  }

  DateRequest getDateInListState(DateRequest dateRequest) {
    for (int i = 0; i < list.length; i++) {
      if (widget.dateFormat.format(dateRequest.dateTime) ==
          widget.dateFormat.format(list[i].dateTime)) {
        return list[i];
      }
    }
    return null;
  }

  List getArrayDateRequest(DateTime dateStart, DateTime dateEnd) {
    List<DateRequest> listDate = new List();
    var currentDate = dateStart;
    while (currentDate.isBefore(dateEnd) || widget.dateFormat.format(currentDate) ==  widget.dateFormat.format(dateEnd)) {
      DateRequest dateRequest = new DateRequest(currentDate, true, true);
      if (currentDate.weekday != DateTime.saturday &&
          currentDate.weekday != DateTime.sunday) {
        listDate.add(dateRequest);
      }
      currentDate = currentDate.add(Duration(days: 1));
    }
    for (int i = 0; i < listDate.length; i++) {
      DateRequest dateCheck = getDateInListState(listDate[i]);
      if (dateCheck != null) {
        listDate[i] = dateCheck;
      }
    }
    setState(() {
      list = listDate;
    });
  }

  void handleChoose(int index, bool isMorning, bool check) {
    for (int i = 0; i < list.length; i++) {
      if (i == index) {
        DateRequest item = list[i];
        if (isMorning) {
          item.hasMorning = !check;
        } else {
          item.hasAfternoon = !check;
        }
        list[i] = item;
      }
    }
    setState(() {});
  }

  bool isHaveDateSelected(){
    for(int i=0; i< list.length; i++){
      if(list[i].hasMorning || list[i].hasAfternoon){
        return true;
      }
    }
    return false;
  }


  handleSubmit(){
    if(!isHaveDateSelected()){
      setState(() {
      });
      return;
    }
    String reason = controllerReason.text;
    if(reason.trim().length == 0){
      setState(() {
        showAlertReason = true;
      });
      return;
    }
    String backup = controllerBackupPlan.text;
    if(widget.requestType == RequestType.Offwork && backup.trim().length == 0){
      setState(() {
        showAlertBackup = true;
      });
      return;
    }
    addRequestBloc.add(AddRequestSendEvent(list, reason, backup, widget.requestType));


  }

  @override
  Widget build(BuildContext context) {
    double width = Utilities.widthScreen(context);
    double widthButton = (width - 40) / 2;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.requestType == RequestType.Remote ?  'Remote request' : 'Offwork Request'),
      ),
      body: BlocBuilder<AddRequestBloc, AddRequestState>(
        builder: (context, state) {
          return Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  showDatePickerFrom(context);
                                },
                                child: Container(
                                  width: width / 2 - 30,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: HexColor('#6e6e6e')),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                            widget.dateFormat.format(dateFrom)),
                                        Image.asset(ImageSource.IMG_CALENDAR,
                                            width: 25, height: 25)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Text('to'),
                              GestureDetector(
                                onTap: () {
                                  showDatePickerTo(context);
                                },
                                child: Container(
                                  width: width / 2 - 30,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: HexColor('#6e6e6e')),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(widget.dateFormat.format(dateTo)),
                                        Image.asset(ImageSource.IMG_CALENDAR,
                                            width: 25, height: 25)
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Center(
                          child: Text(
                              'Total requested time is ' +
                                  list.length.toString() +
                                  ' day(s)',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 0),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: HexColor('#6e6e6e')),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: listviewDateRequest(
                              context, list, widget.dateFormat)),
                    ),
                    Container(
                      child: isHaveDateSelected() ? null : Text('Please select date for request', style: TextStyle(color: Colors.red, fontSize: 10)) ,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        child: Text('Reason*'),
                      ),
                    ),
                    Container(
                      child: Padding(
                      padding: const EdgeInsets.only(top: 3, bottom: 0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: HexColor('#e6e6e6')),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextField(
                            minLines: 4,
                            maxLines: 5,
                            onChanged: (text) {
                              setState(() {
                                showAlertReason = false;
                              });
                            },
                            controller: controllerReason,
                            decoration: InputDecoration.collapsed(
                                hintText: "Your reason"),
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        child: !showAlertReason ? null : Text('Please enter your reason', style: TextStyle(color: Colors.red, fontSize: 10)) ,
                      ),
                    ),
                    Container(
                      child: widget.requestType == RequestType.Offwork ? Text('Back-up Plan*') : null,
                    ),
                    Container(
                      child: widget.requestType == RequestType.Remote ? null : Padding(
                      padding: const EdgeInsets.only(top: 3, bottom: 0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: HexColor('#e6e6e6')),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextField(
                            minLines: 4,
                            maxLines: 5,
                            onChanged: (text){
                              setState(() {
                                showAlertBackup = false;
                              });
                            },
                            controller: controllerBackupPlan,
                            decoration: InputDecoration.collapsed(
                                hintText: "Your backup plan"),
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        child: !showAlertBackup ? null : Text('Please enter your backup plan', style: TextStyle(color: Colors.red, fontSize: 10)) ,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            width: widthButton,
                            height: 45,
                            child: RaisedButton(
                              color: HexColor('#c9ced3'),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: Text('Cancel',
                                  style: TextStyle(color: HexColor('#24282c'))),
                            ),
                          ),
                          SizedBox(
                            width: widthButton,
                            height: 45,
                            child: RaisedButton(
                              color: HexColor('#4da6d4'),
                              onPressed: (){
                                handleSubmit();
                              },
                              child: Text('Submit',
                              style: TextStyle(color: HexColor('#ffffff'))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: state is AddRequestResponseState && !state.isSuscess ? 
                      Text(state.message, textAlign: TextAlign.center ,style: TextStyle(color: Colors.red, fontSize: 15)) : null, 
                    ),
                  ],
                ),
              ),
              Container(
                  child: state is AddRequestLoadingState ? Center(child: CircularProgressIndicator()) : null,
                ),
            
            ],
          );
        },
      ),
    );
  }

  Widget listviewDateRequest(
      BuildContext context, List<DateRequest> list, DateFormat dateFormat) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        DateRequest item = list[index];
        return Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: index != list.length - 1 ? 1.0 : 0,
                      color: HexColor('#6e6e6e')))),
          child: Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: Text(dateFormat.format(item.dateTime),
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          handleChoose(index, true, item.hasMorning);
                        },
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Image.asset(
                                  item.hasMorning
                                      ? ImageSource.IMG_CHECKED
                                      : ImageSource.IMG_UNCHECK,
                                  width: 25,
                                  height: 25),
                            ),
                            Text('Morning'),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          handleChoose(index, false, item.hasAfternoon);
                        },
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Image.asset(
                                  item.hasAfternoon
                                      ? ImageSource.IMG_CHECKED
                                      : ImageSource.IMG_UNCHECK,
                                  width: 25,
                                  height: 25),
                            ),
                            Text('Afternoon'),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
