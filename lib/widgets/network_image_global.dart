import 'package:flutter/material.dart';

class NetworkImageGlobal extends StatelessWidget {
  final String imageUrl;
  final double imageHeight;
  final double imageWidth;

  NetworkImageGlobal({
    required this.imageUrl,
    required this.imageHeight,
    required this.imageWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.fitWidth,
      width: imageWidth,
      height: imageHeight,
      alignment: Alignment.center,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        // Here we can log the error to our analytics or error monitoring service.
        print('Error loading $imageUrl: $exception');

        // Returning a local asset image
        return Image.asset(
          'assets/images/no_img.jpg',
          fit: BoxFit.cover,
          width: imageWidth,
          height: imageHeight,
          alignment: Alignment.center,
        );
      },
    );
  }
}
