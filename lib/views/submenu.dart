import 'package:flutter/material.dart';
import 'package:medmap/const.dart';

class Submenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // Back button icon
            onPressed: () =>
                Navigator.of(context).pop(), // Navigate back when pressed
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(5.0), // Adjust the value as needed
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(height: 10),
                      Text('Profile Name',
                          style: TextStyle(fontSize: 16)), // User's name
                      Text('Company Name',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600])), // User's role
                    ],
                  ),
                  SizedBox(width: 10), // Space between the avatar and the text
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://example.com/profile_picture.jpg'), // Replace with your profile picture URL
                    radius: 30, // Adjust the size of the circle avatar
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white, // Set the body background color to white
        body: CardsLayout(),
      ),
    );
  }
}

class CardsLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(50.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1,
        children: <Widget>[
          Card(
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.black12, width: 1),
            ),
            color: Colors.white, // Ensure the card itself is also white
            elevation: 0, // Remove shadow
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Center(
              // Wrap the Column with Center to center its contents
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    Const.submenu_report,
                    fit: BoxFit.contain,
                    height: 30,
                  ),
                  // Icon(Icons.image, size: 50),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 5.0), // Add padding to the left and right
                    child: Text(
                      'Request Market\nStudy Report',
                      textAlign: TextAlign.center, // Center the text
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.black12, width: 1),
            ),
            color: Colors.white,
            elevation: 0,
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Center(
              // Wrap the Column with Center to center its contents
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    Const.submenu_event,
                    fit: BoxFit.contain,
                    height: 30,
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text('Request for Product Launch Event',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10)),
                  ),
                ],
              ),
            ),
          ),
          Card(
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.black12, width: 1),
            ),
            color: Colors.white,
            elevation: 0,
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Center(
              // Wrap the Column with Center to center its contents
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    Const.submenu_design,
                    fit: BoxFit.contain,
                    height: 30,
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 5.0), // Add padding to the left and right
                    child: Text('Request Product Brochure Design',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10)),
                  ),
                ],
              ),
            ),
          ),
          Card(
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.black12, width: 1),
            ),
            color: Colors.white,
            elevation: 0,
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Center(
              // Wrap the Column with Center to center its contents
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    Const.submenu_privacy,
                    fit: BoxFit.contain,
                    height: 30,
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 5.0), // Add padding to the left and right
                    child: Text('Privacy Policy',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
