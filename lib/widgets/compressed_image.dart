import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class CompressedImage extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double height;

  const CompressedImage({
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  @override
  _CompressedNetworkImageState createState() => _CompressedNetworkImageState();
}

class _CompressedNetworkImageState extends State<CompressedImage> {
  late List<int> compressedImageData = [];

  @override
  void initState() {
    super.initState();
    // print(widget.imageUrl);
    _compressImage();
  }

  Future<void> _compressImage() async {
    try {
      final originalImageData = await http.get(Uri.parse(widget.imageUrl));
      final originalData = originalImageData.bodyBytes;

      final result = await FlutterImageCompress.compressWithList(
        originalData,
        minHeight: 800,
        minWidth: 800,
        quality: 50,
      );

      if (mounted) {
        setState(() {
          compressedImageData = result;
        });
      }
    } catch (e) {
      print('Error compressing image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return compressedImageData.isEmpty
        ? CircularProgressIndicator() // Show a loading indicator while image is being compressed
        : FutureBuilder(
            future: DefaultCacheManager().getSingleFile(widget.imageUrl),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error loading image');
              } else if (!snapshot.hasData) {
                return Text('No image data');
              } else {
                return Image.memory(
                  Uint8List.fromList(compressedImageData),
                  fit: BoxFit
                      .cover, // Adjust the fit based on your UI requirements
                );
              }
            },
          );
  }
}
