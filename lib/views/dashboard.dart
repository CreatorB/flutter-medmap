import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../const.dart';
import '../utils.dart';
import '../default_page.dart';
import '../main.dart';
import '../views/products.dart';
import '../views/browse_products.dart';
import '../views/drugs.dart';
import '../widgets/webview_activity.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import '../AppLanguage.dart';
import '../app_localizations.dart';
import 'package:provider/provider.dart';

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
    return Consumer<AppLanguage>(
      builder: (context, appLanguage, child) {
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
              // PopupMenuButton<String>(
              //   icon: Icon(Icons.language),
              //   onSelected: (String value) {
              //     // Utils.changeLanguage(context, value);
              //     // changeLang(context, value);
              //     // var appLanguage = Provider.of<AppLanguage>(context);
              //     appLanguage.changeLanguage(context, Locale(value));
              //   },
              //   itemBuilder: (BuildContext context) => [
              //     PopupMenuItem<String>(
              //       value: 'en',
              //       child: Text('English'),
              //     ),
              //     PopupMenuItem<String>(
              //       value: 'zh',
              //       child: Text('Chinese'),
              //     ),
              //     PopupMenuItem<String>(
              //       value: 'id',
              //       child: Text('Indonesia'),
              //     ),
              //     // Add more language options as needed
              //   ],
              // ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    // NavigationHistory.addContext(context);
                    // print("cekDashboard : ${context}");
                    final back = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BrowseProducts()),
                    );
                    // if (back == 'back') {
                    //   navbarVisibility(false);
                    // }
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
            margin: EdgeInsets.fromLTRB(0, 0, 0, 60),
            color: Colors
                .white, // Replace with your Const.colorDashboard if it's defined
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircularIconWithTitle(
                      iconPath:
                          'assets/icons/ic_tenders.png', // Replace with your actual image path
                      title: 'Tenders',
                      backgroundColor: Colors.blue,
                      // iconColor: Colors.white,
                      titleColor: Colors.black,
                    ),
                    CircularIconWithTitle(
                      iconPath:
                          'assets/icons/ic_distributors.png', // Replace with your actual image path
                      title: 'Distributors',
                      backgroundColor: Colors.green,
                      // iconColor: Colors.white,
                      titleColor: Colors.black,
                    ),
                    CircularIconWithTitle(
                      iconPath:
                          'assets/icons/ic_products.png', // Replace with your actual image path
                      title: 'Products',
                      backgroundColor: Colors.red,
                      // iconColor: Colors.white,
                      titleColor: Colors.black,
                    ),
                  ],
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.info),
                    title: Text('Card 1'),
                    subtitle: Text('This is the first card.'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.info),
                    title: Text('Card 2'),
                    subtitle: Text('This is the second card.'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CircularIconWithTitle extends StatelessWidget {
  final String iconPath;
  final String title;
  final Color backgroundColor;
  // final Color iconColor;
  final Color titleColor;

  CircularIconWithTitle({
    required this.iconPath,
    required this.title,
    required this.backgroundColor,
    // required this.iconColor,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40, // Adjust the radius as needed
          backgroundColor: backgroundColor,
          child: Image.asset(
            iconPath,
            width: 50, // Adjust the size as needed
            height: 50, // Adjust the size as needed
            // color: iconColor.withOpacity(1.0), // Use withOpacity to control opacity
          ),
        ),
        SizedBox(height: 8), // Add some space between the avatar and the title
        Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: 12, // Adjust the font size as needed
          ),
        ),
      ],
    );
  }
}
