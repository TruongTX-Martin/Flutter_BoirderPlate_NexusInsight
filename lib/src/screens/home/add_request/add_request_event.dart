
import 'package:equatable/equatable.dart';
import 'package:inno_insight/src/screens/home/my_request/my_request_page.dart';
import 'package:intl/intl.dart';
import 'add_request_view.dart';
abstract class AddRequestEvent extends Equatable {
 @override
  List<Object> get props => []; 
}

class AddRequestSendEvent  extends AddRequestEvent {

  List<DateRequest> list;
  String reason;
  String backupPlan;
  RequestType requestType;

  AddRequestSendEvent(List<DateRequest> list, String reason, String backupPlan, RequestType requestType){
    this.list = list;
    this.reason = reason;
    this.backupPlan = backupPlan;
    this.requestType = requestType;
  } 

  Map getParamsRemote() {
    List listItem =  new List();
    for (int i=0; i< list.length; i++) {
      Map mapItem = new Map();
      DateRequest itemRequest = list[i];
      if(itemRequest.hasMorning || itemRequest.hasAfternoon){
        mapItem['date'] = DateFormat('yyyy-MM-dd').format(itemRequest.dateTime);
        mapItem['requestTime'] = DateFormat('yyyy-MM-dd').format(itemRequest.dateTime);
        mapItem['requestTimeSession'] = getRequestTimeSession(itemRequest);
        mapItem['session'] = getRequestTimeSession(itemRequest);
        mapItem['session_value'] = (itemRequest.hasMorning && itemRequest.hasAfternoon) ? 1 : 0.5;
        listItem.add(mapItem);
      }
    }
    Map map = new Map();
    map['reason'] = this.reason;
    map['request_time'] = listItem;
    if(requestType == RequestType.Offwork){
      map['backup_plan'] = 'backupPlan';
    }
    return map;
  }

  String getRequestTimeSession(DateRequest dateRequest){
    if(dateRequest.hasMorning && dateRequest.hasAfternoon){
      return 'day';
    }else if(dateRequest.hasMorning){
      return 'morning';
    }else return 'afternoon';
  }
}


