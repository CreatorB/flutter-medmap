import 'package:flutter/material.dart';
import 'compressed_image.dart';

class NetworkImageGlobal extends StatelessWidget {
  final String? imageUrl;
  final double imageHeight;
  final double imageWidth;

  NetworkImageGlobal({
    this.imageUrl,
    required this.imageWidth,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    print('imageUrl: $imageUrl');
    if (imageUrl == null) {
      // If imageUrl is null, display a local image
      return Image.asset(
        'assets/icons/favicon.ico',
        width: imageWidth,
        height: imageHeight,
        alignment: Alignment.center,
      );
    } else {
      // If imageUrl is not null, display the network image
      return GestureDetector(
        onTap: () => _openImageFullscreen(context, imageUrl!),
        child: Image.network(
          imageUrl!,
          // fit: BoxFit.fitWidth,
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
            print('Error loading $imageUrl: $exception');
            return Image.asset(
              'assets/images/no_img.jpg',
              fit: BoxFit.cover,
              width: imageWidth,
              height: imageHeight,
              alignment: Alignment.center,
            );
          },
        ),
      );
    }
  }
  // @override
  // Widget build(BuildContext context) {
  //   return GestureDetector(
  //     // onTap: () => _openImageFullscreen(context, imageUrl),
  //     child: Image.network(
  //       imageUrl,
  //       // fit: BoxFit.fitWidth,
  //       width: imageWidth,
  //       height: imageHeight,
  //       alignment: Alignment.center,
  //       loadingBuilder: (BuildContext context, Widget child,
  //           ImageChunkEvent? loadingProgress) {
  //         if (loadingProgress == null) return child;
  //         return Center(
  //           child: CircularProgressIndicator(
  //             value: loadingProgress.expectedTotalBytes != null
  //                 ? loadingProgress.cumulativeBytesLoaded /
  //                     loadingProgress.expectedTotalBytes!
  //                 : null,
  //           ),
  //         );
  //       },
  //       errorBuilder:
  //           (BuildContext context, Object exception, StackTrace? stackTrace) {
  //         print('Error loading $imageUrl: $exception');
  //         return Image.asset(
  //           'assets/images/no_img.jpg',
  //           fit: BoxFit.cover,
  //           width: imageWidth,
  //           height: imageHeight,
  //           alignment: Alignment.center,
  //         );
  //       },
  //     ),
  //   );
  // }

  void _openImageFullscreen(BuildContext context, String imageUrl) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Image Preview'),
        ),
        body: Center(
          child: InteractiveViewer(
            child: CompressedImage(
              imageUrl: imageUrl,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              // fit: BoxFit.contain,
            ),
          ),
        ),
      );
    }));
  }
}
