import 'package:flutter/material.dart';

bool isNullOrEmpty(String? str) {
  if (str != null) {
    if (str.isEmpty || str == '') return true;
    return false;
  }
  return true;
}

void openDialog(BuildContext context, String dialogTitle, stringContent,
    String dialogContent) {
  showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: Text(dialogTitle),
          content: Text(dialogContent),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Back'))
          ],
        );
      }));
}
