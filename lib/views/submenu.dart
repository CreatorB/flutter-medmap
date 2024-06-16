import 'package:flutter/material.dart';
import 'package:medmap/const.dart';
import 'package:medmap/models/r_profile.dart';
import 'package:medmap/utils.dart';
import 'package:medmap/views/auth/login.dart';
import 'package:medmap/views/dashboard.dart';
import '../../app_localzations.dart';

class Submenu extends StatefulWidget {
  static const String route = '/submenu';
  Submenu({
    Key? key,
  }) : super(key: key);
  @override
  _SubmenuState createState() => _SubmenuState();
}

class _SubmenuState extends State<Submenu> {
  late String report;
  rProfile? mProfile;
  late String username = 'Username not set';

  Future<String> getUsername() async {
    var fetchedUsername = await Utils.getSpString(Const.USERNAME);
    return fetchedUsername ?? 'Username not set';
  }

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

Future<void> loadProfileData() async {
    var profile = await Utils.getProfile();
    // print('cek profile: $profile');
    if (profile != null) {
      setState(() {
        mProfile = profile;
      });
    } else {
      debugPrint('cek mProfile is null');
    }
    var fetchedUsername = await getUsername();
    setState(() {
      username = fetchedUsername;
    });
  }

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
                      Text(mProfile?.user?.username ?? username,
                          style: TextStyle(fontSize: 16)), // User's name
                      Text(mProfile?.name ?? 'Company not set',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600])), // User's role
                    ],
                  ),
                  SizedBox(width: 10),
                  CircleAvatar(
                    backgroundImage: NetworkImage(mProfile?.logo?.url ?? ''),
                    radius: 30, // Adjust the size of the circle avatar
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Exit'),
                      content: Text('Are you sure you want to exit?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Exit'),
                          onPressed: () async {
                            await Utils.clearSp();
                            await Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Dashboard()),
                              (Route<dynamic> route) => false,
                            );
                            // await Navigator.pushAndRemoveUntil(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => Login()),
                            // );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.white, // Set the body background color to white
        body: CardsLayout(
          report:
              AppLocalizations.of(context)!.translate('market_study_report'),
          event:
              AppLocalizations.of(context)!.translate('product_launch_event'),
          design: AppLocalizations.of(context)!
              .translate('product_brochure_design'),
          policy: AppLocalizations.of(context)!.translate('privacy_policy'),
        ),
      ),
    );
  }
}

class CardsLayout extends StatelessWidget {
  final String report, event, design, policy;

  CardsLayout(
      {required this.report,
      required this.event,
      required this.design,
      required this.policy});

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
                      report,
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
                    child: Text(event,
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
                    child: Text(design,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10)),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Utils.launchURL(context, Const.URL_PRIVACY);
            },
            child: Card(
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
                      child: Text(policy,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
