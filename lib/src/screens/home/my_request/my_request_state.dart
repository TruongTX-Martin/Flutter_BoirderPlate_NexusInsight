import 'package:equatable/equatable.dart';

abstract class MyRequestState extends Equatable {
  const MyRequestState();
  @override
  List<Object> get props => [];
}

class MyRequestStateUnInittialized extends MyRequestState{}

class MyRequestStateError extends MyRequestState {}

class MyRequestStateLoaded extends MyRequestState {
}

