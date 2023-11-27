import 'package:flutter/material.dart';
import 'compressed_image.dart';

class SliderImages extends StatefulWidget {
  final List<String> images; // Replace with your image URLs or assets

  SliderImages({required this.images});

  @override
  _SliderImagesWidgetState createState() => _SliderImagesWidgetState();
}

class _SliderImagesWidgetState extends State<SliderImages> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                // return CompressedImage(
                //   imageUrl: widget.images[index],
                //   width: MediaQuery.of(context)
                //       .size
                //       .width, // Full width of the screen
                //   height: 200, // Replace with your desired height
                // );
                return Image.network(
                  widget.images[
                      index], // Use widget.images[index] for network images
                  fit: BoxFit.cover,
                );
              },
            ),
            _buildDotsIndicator(),
          ],
        ));
  }

  Widget _buildDotsIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.images.map((image) {
          int index = widget.images.indexOf(image);
          return Container(
            width: 8.0,
            height: 8.0,
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentIndex == index ? Colors.blue : Colors.grey,
            ),
          );
        }).toList(),
      ),
    );
  }
}
