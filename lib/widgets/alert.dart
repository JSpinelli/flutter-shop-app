import 'package:flutter/material.dart';

Future<void> alert(context, String error) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An error has ocurred'),
        content:  Text(error),
        actions: <Widget>[
          FlatButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }