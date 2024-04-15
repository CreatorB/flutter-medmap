import 'package:flutter/material.dart';
import 'package:medmap/models/profile_distributor.dart';
import 'package:medmap/utils.dart';
import '../const.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medmap/models/profile_manufacturer.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../models/product_response.dart';
import '../api.dart';
import '../views/browse_products.dart';

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
  String? profileId;
  String? profileVideo;
  bool isLoading = true;
  bool isInitialLoad = true;
  TabController? _tabController;

  final api = Api();
  late ProductResponse productResponse;
  List<Datum> products = [];
  int currentPage = 1;
  int limitItem = 10;
  bool hasMore = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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
          profileId = profileManufacturer?.manufacturer?.id.toString();
          var videoLink = profileManufacturer?.manufacturer?.video;
          if (videoLink != null && videoLink.isNotEmpty) {
            var videoId = Utils.extractVideoId(videoLink);
            profileVideo =
                'https://img.youtube.com/vi/${videoId}/sddefault.jpg';
          }
          isLoading = false;
          fetchProducts();
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
          profileId = profileDistributor?.distributor?.id.toString();
          isLoading = false;
          fetchProducts();
        });
      });
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        hasMore &&
        !isLoading) {
      fetchProducts(page: currentPage + 1);
    }
  }

  Future<void> fetchProducts({int page = 1}) async {
    if (!hasMore || isLoading) return;

    setState(() {
      isLoading = true;
      if (page == 1) {
        isInitialLoad = true;
      }
    });

    try {
      var urls = 'products?page=$page&limit=$limitItem';
      if (widget.type == 'man') {
        urls += '&manufacturer_id=${profileId}';
      } else {
        urls += '&distributor_id=${profileId}';
      }
      final response = await api.fetchData(context, urls);
      // Utils.myLog('cekProducts ${profileId} :' + response.toString());

      if (response is Map<String, dynamic>) {
        ProductResponse newProductResponse = ProductResponse.fromJson(response);
        // print('Meta Total: ${newProductResponse.meta?.total}');

        setState(() {
          if (page == 1) {
            products.clear();
          }
          if (newProductResponse.data.isNotEmpty) {
            products.addAll(newProductResponse.data);
            currentPage = page;
            hasMore = newProductResponse.data.length == limitItem;
          } else {
            hasMore = false;
          }
          isLoading = false;
          isInitialLoad = false;
        });
      } else {
        Utils.showSnackBar(
            context, 'error api products : $response.toString()');
      }
    } catch (error) {
      print('failed fetch products : $error');
      Utils.showSnackBar(context, error.toString());
      setState(() {
        isLoading = false;
        isInitialLoad = false;
      });
    } finally {
      setState(() {
        isLoading = false;
        isInitialLoad = false;
      });
    }
  }

  Future<ProfileManufacturer> fetchProfileManufacturer() async {
    final response = await http
        .get(Uri.parse('${Const.URL_API}/users-manufacturer/${widget.id}'));
    // print('cekProfileResponse : ' + response.body);
    // Utils.myLog('cekProfileMan : ' + response.body);
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
    // Utils.myLog('cekProfileDis : ' + response.body);
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
            : Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 60.0),
                child: Column(
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
                      height: MediaQuery.of(context).size.height,
                      // 200 - // height of the container with image
                      // kToolbarHeight - // height of the app bar
                      // kBottomNavigationBarHeight, // height of the bottom navigation bar
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // About Tab content
                          Container(
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 60.0),
                            child: HtmlWidget(
                              about ?? 'Not available',
                            ),
                          ),
                          // Products Tab content
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 60.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 8.0,
                                      mainAxisSpacing: 8.0,
                                    ),
                                    itemCount: products.length,
                                    controller: _scrollController,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailProducts(
                                                      item: products[index]),
                                            ),
                                          );
                                        },
                                        child: GridItem(item: products[index]),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Videos Tab content
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 60.0),
                            child: GestureDetector(
                              onTap: () {
                                if (profileManufacturer?.manufacturer?.video !=
                                    null) {
                                  Utils.launchURL(
                                      context,
                                      profileManufacturer!
                                          .manufacturer!.video!);
                                }
                              },
                              child: Column(
                                children: [
                                  if (profileVideo != null)
                                    Image.network(
                                      profileVideo ??
                                          'assets/images/no_img.jpg',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                    ),
                                  if (profileVideo == null)
                                    Text(
                                      'No video available',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
