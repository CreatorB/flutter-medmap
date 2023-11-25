import 'package:flutter/material.dart';

class BrowseProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Another Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.of(context).pop(); // Navigate back when pressed
            Navigator.pop(context, 'back');
          },
        ),
      ),
      body: Center(
        child: Text('This is another page'),
      ),
    );
  }
}
