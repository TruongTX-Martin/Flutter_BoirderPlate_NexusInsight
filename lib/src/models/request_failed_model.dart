class RequestFailedModel {
  bool isSuccess;
  String type;
  String title;
  int status;
  int errorCode;
  String detail;
  

  RequestFailedModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    type = json['type'];
    title = json['title'];
    status = json['status'];
    errorCode = json['errorCode'];
    detail = json['detail'];
  }

  bool get getIsSuccess => isSuccess;
  String get getType => type;
  String get getTitle => title;
  int get getErrorCode => errorCode;
  String get getDetail => detail;
}

class InvalidParam {
  String name;
  String message;
  InvalidParam.fromJson(Map<String, dynamic> json) {
    name = json['email'];
    message = json['email'];
  }

  String get getName => name;

  String get getMessage => message;
}
