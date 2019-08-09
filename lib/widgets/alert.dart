import 'package:flutter/material.dart';

Future<void> alert(context) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An error has ocurred'),
        content: const Text('Something went wrong Dude'),
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