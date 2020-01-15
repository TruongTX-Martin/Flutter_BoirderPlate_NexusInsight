

import 'package:equatable/equatable.dart';

abstract class MyRequestEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class MyRequestEventFetch extends MyRequestEvent {}

class MyRequestEventPullToRefresh extends MyRequestEvent {}

class MyRequestEventFetchMore extends MyRequestEvent{}

class MyRequestEventFailure extends MyRequestEvent {}

class MyRequestEventSuccess  extends MyRequestEvent {}