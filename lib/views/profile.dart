// import 'package:flutter/material.dart';

// class Profile extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Container(
//             height: 200, // Set the height of the container
//             width: double.infinity, // Make the container take the full width
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Colors.blue, // Top color
//                   Colors.red, // Bottom color
//                 ],
//               ),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Centered logo
//                 ClipOval(
//                   child: Image.asset(
//                     'assets/icons/favicon.ico', // Path to your logo
//                     width: 100, // Adjust the size as needed
//                     height: 100, // Adjust the size as needed
//                   ),
//                 ),
//                 Text(
//                   'Profile Name',
//                   style: TextStyle(
//                     fontSize: 24, // Adjust the font size as needed
//                     color: Colors.black, // Adjust the color as needed
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../const.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Stack(
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    color: Const.primaryBlue,
                  ),
                  Positioned(
                    top: 150,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Const.primaryBlue,
                              width: 2.0,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/icons/favicon.ico',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(
                          'Profile Name',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
