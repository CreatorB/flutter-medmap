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
import '../api.dart';
import '../models/affair_response.dart';

class Dashboard extends StatefulWidget {
  static const String route = '/dashboard';
  Dashboard({
    Key? key,
  }) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Dashboard> {
  final api = Api();
  late AffairResponse affairResponse;
  List<Data> datum = [];
  int currentPage = 1;
  int limitItem = 3;
  String keyword = "";
  // bool hasMore = true;
  // bool isLoading = false;
  // bool isInitialLoad = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData({int page = 1}) async {
    try {
      final response = await api.fetchData(
          context, 'gov-affairs?page=$page&limit=$limitItem');
      if (response != null) {
        AffairResponse newResponse = AffairResponse.fromJson(response);
        setState(() {
          if (page == 1) {
            datum = newResponse.data ?? [];
          } else {
            datum.addAll(newResponse.data ?? []);
          }
          currentPage = page;
        });
      } else {
        Utils.showSnackBar(context, 'Failed to load data');
      }
    } catch (e) {
      Utils.showSnackBar(context, e.toString());
      // isLoading = false;
    }
  }

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
          body: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 60),
            color: Colors
                .white, // Replace with your Const.colorDashboard if it's defined
            child: Column(
              children: [
                // SearchInputBox(),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircularIconWithTitle(
                      onTap: () {
                        selectTab(1);
                      },
                      iconPath:
                          'assets/icons/ic_tenders.png', // Replace with your actual image path
                      title: 'Tenders',
                      backgroundColor: Color(0xFFDCE3FD),
                      // iconColor: Colors.white,
                      titleColor: Colors.black,
                    ),
                    CircularIconWithTitle(
                      onTap: () {
                        selectTab(3);
                      },
                      iconPath:
                          'assets/icons/ic_distributors.png', // Replace with your actual image path
                      title: 'Distributors',
                      backgroundColor: Color(0xFFFFE7E7),
                      // iconColor: Colors.white,
                      titleColor: Colors.black,
                    ),
                    CircularIconWithTitle(
                      onTap: () {
                        selectTab(2);
                      },
                      iconPath:
                          'assets/icons/ic_products.png', // Replace with your actual image path
                      title: 'Products',
                      backgroundColor: Color(0xFFFCEEE1),
                      // iconColor: Colors.white,
                      titleColor: Colors.black,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircularIconWithTitle(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Drugs()),
                        );
                      },
                      iconPath: 'assets/icons/ic_pharmacy.png',
                      title: 'e-Pharmacy',
                      backgroundColor: Color(0xFFF6EFC6),
                      // iconColor: Colors.white,
                      titleColor: Colors.black,
                    ),
                    CircularIconWithTitle(
                      onTap: () {
                        Utils.openPDFFromAssets(
                            context, 'assets/pdfs/content_service.pdf');
                      },
                      iconPath: 'assets/icons/ic_services.png',
                      title: 'Services',
                      backgroundColor: Color(0xFFE3F3EA),
                      // iconColor: Colors.white,
                      titleColor: Colors.black,
                    ),
                    CircularIconWithTitle(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WebViewActivity(
                                title: 'Events & News',
                                url: Const.URL_WEB + '/all-news'),
                          ),
                        );
                      },
                      iconPath: 'assets/icons/ic_events.png',
                      title: 'Events',
                      backgroundColor: Color(0xFFD3F2FF),
                      // iconColor: Colors.white,
                      titleColor: Colors.black,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                        child: Text(
                          'Recommended Tenders',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            // fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0, top: 16.0),
                        child: Text(
                          'View All',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.grey,
                            // fontSize: 13,
                            fontFamily: 'Inter',
                            height: 0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Expanded(
                //   child: ListView.separated(
                //     controller: _scrollController,
                //     itemCount: datum.length,
                //     itemBuilder: (context, index) {
                //       if (index == datum.length) {
                //         return Center(
                //           child: CircularProgressIndicator(),
                //         );
                //       }
                //       final item = datum[index];
                //       return Card(
                //         color: Colors.white,
                //         margin: EdgeInsets.all(8.0),
                //         child: InkWell(
                //           onTap: () {},
                //           child: Padding(
                //             padding: const EdgeInsets.all(16.0),
                //             child: Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 Row(
                //                   mainAxisAlignment:
                //                       MainAxisAlignment.spaceBetween,
                //                   children: [
                //                     Text(
                //                       item.title ?? 'Not provided',
                //                       style: TextStyle(
                //                         color: Color(0xFF150A33),
                //                         fontSize: 14,
                //                         fontFamily: 'Inter',
                //                         fontWeight: FontWeight.w700,
                //                       ),
                //                     ),
                //                     // Three-dot menu
                //                     PopupMenuButton<String>(
                //                       onSelected: (String result) {
                //                         // Handle menu item selection
                //                       },
                //                       itemBuilder: (BuildContext context) =>
                //                           <PopupMenuEntry<String>>[],
                //                     ),
                //                   ],
                //                 ),
                //                 Text(
                //                   item.country?.name ?? 'Not provided',
                //                   style: TextStyle(
                //                     color: Color(0xFF514A6B),
                //                     fontSize: 12,
                //                     fontFamily: 'Open Sans',
                //                     fontWeight: FontWeight.w400,
                //                     height: 0,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ),
                //       );
                //     },
                //     separatorBuilder: (context, index) => SizedBox(height: 0),
                //   ),
                // ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.image),
                      title: Text('Item Recommended Tenders'),
                      subtitle: Text('Coming soon.'),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Medical Policy Affairs',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            // fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text(
                          'View All',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.grey,
                            // fontSize: 13,
                            fontFamily: 'Inter',
                            height: 0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.image),
                      title: Text('Item Medical Affairs'),
                      subtitle: Text('Coming soon.'),
                    ),
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
  final VoidCallback onTap;

  CircularIconWithTitle({
    required this.iconPath,
    required this.title,
    required this.backgroundColor,
    // required this.iconColor,
    required this.titleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            SizedBox(
                height: 8), // Add some space between the avatar and the title
            Text(
              title,
              style: TextStyle(
                color: titleColor,
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchInputBox extends StatefulWidget {
  @override
  _SearchInputBoxState createState() => _SearchInputBoxState();
}

class _SearchInputBoxState extends State<SearchInputBox> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller, // Assign the controller to the TextField
      onSubmitted: (value) {
        // Handle search action here
        print('Search submitted: $value');
      },
      decoration: InputDecoration(
        prefixIcon: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            // Handle search action here
            print('Search submitted: ${_controller.text}');
          },
        ),
        labelText: 'Search',
        border: OutlineInputBorder(),
      ),
    );
  }
}
