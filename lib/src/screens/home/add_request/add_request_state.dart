

import 'package:equatable/equatable.dart';

abstract class AddRequestState extends Equatable {
  @override
  List<Object> get props => [];
}

class AddRequestInitState extends AddRequestState {}

class AddRequestLoadingState extends AddRequestState {}

class AddRequestResponseState extends AddRequestState {

  bool isSuscess;
  String message;

  AddRequestResponseState(bool success, String message){
    this.isSuscess = success;
    this.message = message;
  }

}




