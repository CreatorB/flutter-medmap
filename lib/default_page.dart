import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class DefaultPage extends StatelessWidget {
  const DefaultPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dev Page'),
      ),
      body: Center(
        // Navigator.pop(context);
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo or Image
            // SvgPicture.asset(
            //   'lib/assets/icons/medmap_logo.svg',
            //   semanticsLabel: 'medmap_logo',
            //   placeholderBuilder: (BuildContext context) =>
            //       CircularProgressIndicator(),
            // ),
            Image.asset('assets/icons/medmap_banner.png',
                // width: 100,
                height:
                    50), // Replace 'assets/logo.png' with your logo image path
            Text(
              'Coming Soon ...',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 18.0, // You can also set other text styles as needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}
