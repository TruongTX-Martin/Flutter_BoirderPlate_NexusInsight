import 'package:equatable/equatable.dart';
import 'package:inno_insight/src/models/models.dart';

abstract class MyRequestState extends Equatable {
  const MyRequestState();
  @override
  List<Object> get props => [];
}

class MyRequestStateUnInittialized extends MyRequestState{}

class MyRequestStateLoading extends MyRequestState{}

class MyRequestStateError extends MyRequestState {}

class MyRequestStateLoaded extends MyRequestState {
  
  List<RequestModel> listRequest;

  MyRequestStateLoaded({ this.listRequest});

  @override
  List<Object> get props => [listRequest.length];
  

  @override
  String toString() {
    return 'MyRequestStateLoaded data is ${listRequest.length}';
  }

}

