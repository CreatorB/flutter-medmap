import 'package:flutter/material.dart';
import 'package:medmap/models/profile_distributor.dart';
import 'package:medmap/utils.dart';
import '../const.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medmap/models/profile_manufacturer.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class Profile extends StatefulWidget {
  final int id;
  final String type;

  Profile({required this.id, required this.type});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  ProfileManufacturer? profileManufacturer;
  ProfileDistributor? profileDistributor;
  String? profileName;
  String? cityName;
  String? webLink;
  String? about;
  bool isLoading = true;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    if (widget.type == 'man') {
      fetchProfileManufacturer().then((value) {
        setState(() {
          profileManufacturer = value;
          profileName =
              profileManufacturer?.manufacturer?.name ?? 'Not Available';
          cityName = profileManufacturer?.manufacturer?.country?.name;
          webLink = profileManufacturer?.manufacturer?.website;
          about = profileManufacturer?.manufacturer?.about;
          isLoading = false;
        });
      });
    } else {
      fetchProfileDistributor().then((value) {
        setState(() {
          profileDistributor = value;
          profileName =
              profileDistributor?.distributor?.name ?? 'Not Available';
          cityName = profileDistributor?.distributor?.country?.name;
          webLink = profileDistributor?.distributor?.website;
          about = profileDistributor?.distributor?.about;
          isLoading = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<ProfileManufacturer> fetchProfileManufacturer() async {
    final response = await http
        .get(Uri.parse('${Const.URL_API}/users-manufacturer/${widget.id}'));
    // print('cekProfileResponse : ' + response.body);
    Utils.myLog('cekProfileResponse : ' + response.body);
    // Utils.myLog(response.body);
    if (response.statusCode == 200) {
      return ProfileManufacturer.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch profile manufacturer');
    }
  }

  Future<ProfileDistributor> fetchProfileDistributor() async {
    final response = await http
        .get(Uri.parse('${Const.URL_API}/users/distributor/${widget.id}'));
    // Utils.myLog(response.body);
    Utils.myLog('cekProfileResponse : ' + response.body);
    if (response.statusCode == 200) {
      return ProfileDistributor.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch profile distributor');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == 'man'
            ? 'Manufacture Profile'
            : 'Distributor Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Container(
                          height: 100,
                          width: double.infinity,
                          color: Const.primaryBlue,
                        ),
                        Positioned(
                          top: 100,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: 100,
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
                                height: 50,
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
                                    width: 75,
                                    height: 75,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                profileName ?? 'Not Available',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                cityName ?? 'Not Available',
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (webLink != null) {
                                    Utils.launchURL(context, webLink!);
                                  }
                                },
                                child: Text(
                                  webLink ?? 'Not Available',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(text: 'About'),
                      Tab(text: 'Products'),
                      Tab(text: 'Videos'),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height -
                        200 - // height of the container with image
                        kToolbarHeight - // height of the app bar
                        kBottomNavigationBarHeight, // height of the bottom navigation bar
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // About Tab content
                        ListView(
                          padding: EdgeInsets.all(16),
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                  maxHeight: MediaQuery.of(context)
                                          .size
                                          .height -
                                      200 -
                                      kToolbarHeight -
                                      kBottomNavigationBarHeight -
                                      48), // Adjust the maxHeight value according to your needs
                              child: HtmlWidget(
                                about ?? 'Not available',
                              ),
                            ),
                          ],
                        ),
                        // Products Tab content
                        Container(
                          padding: EdgeInsets.all(16),
                          child: Text('Products Tab Content'),
                        ),
                        // Videos Tab content
                        Container(
                          padding: EdgeInsets.all(16),
                          child: Text('Videos Tab Content'),
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
