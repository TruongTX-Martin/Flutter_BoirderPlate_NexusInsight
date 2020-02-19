import 'package:flutter/material.dart';

class Utilities {
  static widthScreen(context) {
    var screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    return width;
  }

  static showDialogWithCancel({BuildContext context, String title, String message, Function onCancel, Function onOk}){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                onCancel();
              },
            ),
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                onOk();
              },
            ),
          ],
        );
      },
    );
  }


}