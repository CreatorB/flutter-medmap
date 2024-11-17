import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class ServiceRequestDetails extends StatefulWidget {
  final String fullDescription;

  ServiceRequestDetails({Key? key, required this.fullDescription})
      : super(key: key);

  @override
  _ServiceRequestDetailsState createState() => _ServiceRequestDetailsState();
}

class _ServiceRequestDetailsState extends State<ServiceRequestDetails> {
  late FleatherController _controller;

  @override
  void initState() {
    super.initState();
    final description = widget.fullDescription != null
        ? jsonDecode(widget.fullDescription) as List<dynamic>
        : [];

    final document = ParchmentDocument.fromJson(description);

    _controller = FleatherController(document: document);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Request Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FleatherEditor(
          controller: _controller,
          focusNode: FocusNode(),
          embedBuilder: (context, node) {
            if (node.value.type == 'image') {
              final data = node.value.data;
              String? imageUrl;
              imageUrl = data['source'] as String?;
              if (imageUrl != null) {
                // print("Image URL: $imageUrl");
                return Image.network(imageUrl);
              } else {
                return Text('Invalid image data');
              }
            }
            return Text('Unsupported embed type: ${node.value.type}');
          },
        ),
      ),
    );
  }
}
