import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../const.dart';
import '../default_page.dart';
import '../main.dart';
import '../views/products.dart';
import '../views/browse_products.dart';
// import '../views/myblog.dart';

class Dashboard extends StatefulWidget {
  static const String route = '/dashboard';
  Dashboard({
    Key? key,
  }) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.blue[0],
          // backgroundColor: Colors.white70,
          // backgroundColor: Colors.white
          //     .withOpacity(0.70), // Replace with your color and opacity
          // centerTitle: true,
          elevation: 2,
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  Const.banner,
                  fit: BoxFit.contain,
                  height: 30,
                ),
                // Container(
                //   child: Text("  APP BAR"),
                // )
              ],
            ),
          ),
          actions: [
            Container(
              margin:
                  EdgeInsets.only(right: 16.0), // Adjust the margin as needed
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  // NavigationHistory.addContext(context);
                  // print("cekDashboard : ${context}");

                  navbarVisibility(true);
                  final back = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BrowseProducts()),
                  );
                  if (back == 'back') {
                    navbarVisibility(false);
                  }
                },
                // color: Colors.white,
              ),
            )
          ],
        ),
        // backgroundColor: Colors.blue[100],
        // backgroundColor: Colors.white70,
        // backgroundColor: Colors.white.withOpacity(
        //     0.7099999785423279), // Replace with your color and opacity
        body: Container(
          child: Container(
            color: Const.colorDashboard,
            // color: Colors.blue[20],
            // color: Colors.white.withOpacity(
            //     0.7099999785423279), // Replace with your color and opacity
            // color: Colors.white10,
            // padding: const EdgeInsets.only(top: 20.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0, // Adjust as needed
              mainAxisSpacing: 15.0, // Adjust as needed
              children: <Widget>[
                InkWell(
                  // padding: const EdgeInsets.all(12.0),
                  onTap: () {
                    selectTab(1);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        // padding: const EdgeInsets.all(12.0),
                        Const.imgMenuTenders, // Replace with your image URL
                        width: 150,
                        height: 150,
                        // fit: BoxFit
                        //     .cover, // Adjust the BoxFit property as needed
                      ),
                      SizedBox(
                          height:
                              20.0), // Add some space between image and text
                      Text(
                        'Tenders',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 17,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          height: 0.08,
                        ),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    selectTab(3);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Const
                            .imgMenuDistributors, // Replace with your image URL
                        // width: double.infinity,
                        width: 150,
                        height: 150,
                        // fit: BoxFit
                        //     .cover, // Adjust the BoxFit property as needed
                        // width: 100.0, // Adjust the width as needed
                        // height: 100.0, // Adjust the height as needed
                      ),
                      SizedBox(
                          height:
                              20.0), // Add some space between image and text
                      Text(
                        'Distributors',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 17,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          height: 0.08,
                        ),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => Products()),
                    // );
                    selectTab(2);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Const.imgMenuProducts, // Replace with your image URL
                        width: 150.0, // Adjust the width as needed
                        height: 150.0, // Adjust the height as needed
                      ),
                      SizedBox(
                          height:
                              20.0), // Add some space between image and text
                      Text(
                        'Products',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 17,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          height: 0.08,
                        ),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DefaultPage()),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Const
                            .imgMenuRegistrations, // Replace with your image URL
                        width: 150.0, // Adjust the width as needed
                        height: 150.0, // Adjust the height as needed
                      ),
                      SizedBox(
                          height:
                              20.0), // Add some space between image and text
                      Text(
                        'Events',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 17,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          height: 0.08,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
