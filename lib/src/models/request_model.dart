class RequestModel {
  int id;
  String employee;
  String category;
  String reason;
  String backupPlan;
  String verdictNote;
  String compliance;
  String status;
  String noteCompliance;
  RequestTime requestTime;
  SubmittedTimes submittedTimes;

  RequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employee = json['employee'];
    category = json['category'];
    reason = json['reason'];
    backupPlan = json['backupPlan'];
    verdictNote = json['verdictNote'];
    compliance = json['compliance'];
    status = json['status'];
    noteCompliance = json['noteCompliance'];
    requestTime = parserRequestTime(json['requestTimes']);
    submittedTimes = parserSubmitTime(json['submittedTimes']);
  }

   parserRequestTime(List<dynamic> data) {
   return  RequestTime.fromJson(data[0]);
  }

  parserSubmitTime(List<dynamic> data){
    return SubmittedTimes.fromJson(data[0]);
  }


  int get getId => id;

  String get getEmployee => employee;

  String get getCategory => category + ' work';
  String get getReason => reason;
  String get getBackupPlan => backupPlan;
  String get getVerdictNote => verdictNote;
  String get getCompliance => compliance;
  String get getStatus => status;
  String get getNoteCompliance => noteCompliance;
  RequestTime get getRequestTime => requestTime;
  SubmittedTimes get getSubmitAt => submittedTimes;
}

class RequestTime {
  int requestId;
  String requestTime;
  String requestTimeSession;


  RequestTime.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    requestTime = json['requestTime'];
    requestTimeSession = json['requestTimeSession'];
  }

  int get getRequestId => requestId;

  String get getRequestTime => requestTime + (requestTimeSession == 'day' ? ' (1 days)' : ' (0.5 day)');

  String get getRequestTimeSession => requestTimeSession;
}

class SubmittedTimes {
  int requestId;
  String submittedTime;

  SubmittedTimes.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    submittedTime = json['submittedTime'];
  }

  int get getRequestId => requestId;

  String get getSubmittedTime => submittedTime;
}
