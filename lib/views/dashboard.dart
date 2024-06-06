import 'package:flutter/material.dart';
import 'package:medmap/views/submenu.dart';

import '../const.dart';
import '../utils.dart';
import '../main.dart';
import '../views/browse_products.dart';
import '../views/drugs.dart';
import '../views/analysis.dart' as listAnalysis;
import '../views/affair.dart' as listAffair;
import '../views/news.dart' as listNews;

import '../AppLanguage.dart';
import 'package:provider/provider.dart';
import '../api.dart';
import '../models/analysis_response.dart' as analysis;
import '../models/affair_response.dart' as affair;

class Dashboard extends StatefulWidget {
  static const String route = '/dashboard';
  Dashboard({
    Key? key,
  }) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final api = Api();
  late analysis.AnalysisResponse analysisResponse;
  late affair.AffairResponse affairResponse;
  List<analysis.Data> datum = [];
  List<affair.Data> datumAffair = [];
  int currentPage = 1;
  int limitItem = 3;
  String keyword = "";
  // bool hasMore = true;
  // bool isLoading = false;
  // bool isInitialLoad = true;
  late ScrollController _scrollController;
  bool _isScrolledToEnd = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          setState(() {
            _isScrolledToEnd = true;
          });
        } else {
          setState(() {
            _isScrolledToEnd = false;
          });
        }
      });
    getAnalysis();
    getAffairs();
  }

  Future<void> getAnalysis({int page = 1}) async {
    try {
      final response = await api.fetchData(
          context, 'cases-analysis?page=$page&limit=$limitItem');
      if (response != null) {
        analysisResponse = analysis.AnalysisResponse.fromJson(response);
        setState(() {
          if (page == 1) {
            datum = analysisResponse.data ?? [];
          } else {
            datum.addAll(analysisResponse.data ?? []);
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

  Future<void> getAffairs({int page = 1}) async {
    try {
      final response = await api.fetchData(context,
          'gov-affairs?sort=created_at&order=desc&page=$page&limit=$limitItem');
      if (response != null) {
        affairResponse = affair.AffairResponse.fromJson(response);
        setState(() {
          if (page == datumAffair) {
            datumAffair = affairResponse.data ?? [];
          } else {
            datumAffair.addAll(affairResponse.data ?? []);
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
                  icon: Icon(Icons.perm_identity),
                  onPressed: () async {
                    // NavigationHistory.addContext(context);
                    // print("cekDashboard : ${context}");
                    final back = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Submenu()),
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
            color: Colors.white,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  SearchInputBox(),
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
                                builder: (context) => listNews.News()),
                          );
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => WebViewActivity(
                          //         title: 'Events & News',
                          //         url: Const.URL_WEB + '/all-news'),
                          //   ),
                          // );
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
                            'Breakthrough Case Studies',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(right: 16.0, top: 16.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        listAnalysis.Analysis()),
                              );
                            },
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
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 300, // Specify the fixed height for the ListView
                    child: ListView.separated(
                      itemCount: datum.length,
                      itemBuilder: (context, index) {
                        if (index == datum.length) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final item = datum[index];
                        return Card(
                          color: Colors.white,
                          margin: EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      listAnalysis.DetailPage(item: item),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // Align items vertically at the start
                                    children: [
                                      if (item.image?.url != null)
                                        Image.network(
                                          item.image!.url!,
                                          width:
                                              50, // Adjust the width as needed
                                          height:
                                              50, // Adjust the height as needed
                                          fit: BoxFit
                                              .cover, // Adjust the fit as needed
                                        ),
                                      SizedBox(
                                          width:
                                              10), // Add some space between the image and the text
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 10),
                                            Text(
                                              Utils.fmtToDMY(item.createdAt),
                                              style: TextStyle(
                                                color: Color(0xFF514A6B),
                                                fontSize: 12,
                                                fontFamily: 'Open Sans',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                              ),
                                            ),
                                            Text(
                                              Utils.trimString(item.title),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: Color(0xFF150A33),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              'Read More',
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 11,
                                                fontFamily: 'Open Sans',
                                                height: 0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 0),
                    ),
                  ),
                  // SizedBox(height: 10),
                  // Container(
                  //   margin: EdgeInsets.symmetric(horizontal: 16.0),
                  //   child: Card(
                  //     child: ListTile(
                  //       leading: Icon(Icons.image),
                  //       title: Text('Item Recommended Tenders'),
                  //       subtitle: Text('Coming soon.'),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 15),
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
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => listAffair.Affair()),
                              );
                            },
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
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 300, // Specify the fixed height for the ListView
                    child: ListView.separated(
                      itemCount: datumAffair.length,
                      itemBuilder: (context, index) {
                        if (index == datumAffair.length) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final item = datumAffair[index];
                        return Card(
                          color: Colors.white,
                          margin: EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      listAffair.DetailPage(item: item),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // Align items vertically at the start
                                    children: [
                                      if (item.image?.url != null)
                                        Image.network(
                                          item.image!.url!,
                                          width:
                                              50, // Adjust the width as needed
                                          height:
                                              50, // Adjust the height as needed
                                          fit: BoxFit
                                              .cover, // Adjust the fit as needed
                                        ),
                                      SizedBox(
                                          width:
                                              10), // Add some space between the image and the text
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 10),
                                            Text(
                                              Utils.fmtToDMY(item.createdAt),
                                              style: TextStyle(
                                                color: Color(0xFF514A6B),
                                                fontSize: 12,
                                                fontFamily: 'Open Sans',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                              ),
                                            ),
                                            Text(
                                              Utils.trimString(item.title),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: Color(0xFF150A33),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              'Read More',
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 11,
                                                fontFamily: 'Open Sans',
                                                height: 0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: FloatingActionButton(
              onPressed: () {
                if (_isScrolledToEnd) {
                  // Scroll to the top of the list
                  _scrollController.animateTo(
                    0,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 500),
                  );
                } else {
                  // Scroll to the end of the list
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 500),
                  );
                }
              },
              child: Icon(
                  _isScrolledToEnd ? Icons.arrow_upward : Icons.arrow_downward),
              tooltip: _isScrolledToEnd ? 'Scroll to Top' : 'Scroll to End',
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation
              .endFloat, // Set the location of the FAB
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
    return Container(
      margin: EdgeInsets.fromLTRB(
          30.0, 20.0, 30.0, 10.0), // Set margin around the entire TextField
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft:
              Radius.circular(50.0), // Adjust these values for the oval shape
          topRight:
              Radius.circular(50.0), // Adjust these values for the oval shape
          bottomLeft:
              Radius.circular(50.0), // Adjust these values for the oval shape
          bottomRight:
              Radius.circular(50.0), // Adjust these values for the oval shape
        ),
        child: TextField(
          controller: _controller, // Assign the controller to the TextField
          onSubmitted: (value) {
            // Handle search action here
            // print('Search submitted: $value');
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BrowseProducts(keyword: value)),
            );
          },
          decoration: InputDecoration(
            filled: true, // Enable filling the TextField with a color
            fillColor: Colors.grey[100], // Set the background color to grey
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            prefixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Handle search action here
                print('Search submitted: ${_controller.text}');
              },
            ),
            hintText: 'Search...',
            border: InputBorder.none, // Remove border
            focusedBorder: InputBorder.none, // Remove border when focused
            enabledBorder: InputBorder.none, // Remove border when enabled
            errorBorder:
                InputBorder.none, // Remove border when there's an error
            disabledBorder: InputBorder.none, // Remove border when disabled
            // suffixIcon: IconButton(
            //   icon: Icon(Icons.clear),
            //   onPressed: () {
            //     _controller.clear();
            //   },
            // ),
          ),
        ),
      ),
    );
  }
}
