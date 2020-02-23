import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_insight/src/repositories/repository_helper.dart';
import 'package:inno_insight/src/screens/home/add_request/add_request.dart';
import 'package:inno_insight/src/screens/home/add_request/add_request_view.dart';
import 'package:inno_insight/src/screens/home/my_request/my_request_page.dart';


class AddRequestPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
     final RequestType args = ModalRoute.of(context).settings.arguments;
    return Container(
      child: BlocProvider(
        create: (context) => AddRequestBloc(userRepository: RepositoryHelper.userRepository, context: context),
        child: AddRequestView(args),
      )
    );
  }
}