import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import '../models/manufacturer_response.dart';
import '../utils.dart';
import '../api.dart';
import '../widgets/network_image_global.dart';
import '../app_localzations.dart';
import 'package:medmap/route/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';

class Outsourcing extends StatefulWidget {
  @override
  _OutsourcingState createState() => _OutsourcingState();
}

class _OutsourcingState extends State<Outsourcing> {
  final api = Api();
  late ManufacturerResponse dataResponse;
  List<ManufacturerData> datum = [];
  int currentPage = 1;
  int limitItem = 10;
  String keyword = "";
  bool hasMore = true;
  bool isLoading = false;
  bool isInitialLoad = true;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    fetchData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        hasMore &&
        !isLoading) {
      fetchData(page: currentPage + 1);
    }
  }

  Future<void> storeCompanyId(String companyId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('company_id', companyId);
    log('Stored company_id: $companyId');
  }

  Future<void> fetchData({int page = 1}) async {
    if (!hasMore || isLoading) return;

    setState(() {
      isLoading = true;
      if (page == 1) {
        isInitialLoad = true;
      }
    });

    try {
      final response = await api.fetchData(context,
          'users-manufacturer?page=$page&limit=$limitItem&sort=id&order=desc');

      if (response != null) {
        ManufacturerResponse newResponse =
            ManufacturerResponse.fromJson(response);

        setState(() {
          if (page == 1) {
            datum = newResponse.data;
          } else {
            datum.addAll(newResponse.data);
          }
          currentPage = page;
          hasMore = newResponse.data.length == limitItem;
          isInitialLoad = false;
        });
      } else {
        Utils.showSnackBar(context, 'Failed to load data');
      }
    } catch (e) {
      Utils.showSnackBar(context, e.toString());
      // isLoading = false;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _updateSearchKeyword(String newKeyword) {
    setState(() {
      keyword = newKeyword;
      currentPage = 1;
      datum = [];
      hasMore = true;
    });
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter keyword ...',
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  _updateSearchKeyword(value);
                },
              )
            : Text(
                AppLocalizations.of(context)!.translate('search_outsourcing'),
              ),
        actions: [
          isSearching
              ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                      _searchController.clear();
                      _updateSearchKeyword('');
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      isSearching = true;
                    });
                  },
                ),
        ],
      ),
      body: isInitialLoad
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => fetchData(page: 1),
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 60.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate('new_outsourcing'),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        controller: _scrollController,
                        itemCount: datum.length + (hasMore ? 1 : 0),
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
                                        DetailPage(item: item),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(
                                          8.0), // Adjust the padding values as needed
                                      child: ClipOval(
                                        child: NetworkImageGlobal(
                                          imageUrl: item.logo?.url,
                                          imageWidth: 75,
                                          imageHeight: 75,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Yode this Column
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                (item.name?.length ?? 0) > 25
                                                    ? '${item.name!.substring(0, 25)}...'
                                                    : item.name ??
                                                        'Not provided',
                                                style: TextStyle(
                                                  color: Color(0xFF150A33),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              // Three-dot menu
                                              PopupMenuButton<String>(
                                                onSelected: (String result) {
                                                  // Handle menu item selection
                                                },
                                                itemBuilder: (BuildContext
                                                        context) =>
                                                    <PopupMenuEntry<String>>[],
                                              ),
                                            ],
                                          ),
                                          Text(
                                            item.country?.name ??
                                                'Not provided',
                                            style: TextStyle(
                                              color: Color(0xFF514A6B),
                                              fontSize: 12,
                                              fontFamily: 'Open Sans',
                                              fontWeight: FontWeight.w400,
                                              height: 0,
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
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final ManufacturerData item;

  DetailPage({Key? key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(bottom: 60),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 150,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: NetworkImageGlobal(
                  imageUrl: item.logo?.url ?? '',
                  imageWidth: double.infinity,
                  imageHeight: double.infinity,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        // Retrieve the user ID from shared preferences
                        final companyId = item.userId;
                        log('Mendaptakan userID dari outsourcing: $companyId');

                        // Store the company ID in shared preferences
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString(
                            'company_id', companyId.toString());
                        log('Stored company_id: $companyId');

                        // Navigate to the service request page with the user ID
                        log('Navigating to: ${AppRoutes.service_request}',
                            name: 'Navigation', error: 'Extra: $companyId');
                        context.push(AppRoutes.service_request,
                            extra: companyId);
                      },
                      child: Text(
                        'Request Service',
                        style: TextStyle(
                          color: Colors
                              .blue, // Teks dengan warna biru untuk menunjukkan interaksi
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          decoration:
                              TextDecoration.underline, // Teks bergaris bawah
                        ),
                      ),
                    ),

                    SizedBox(
                        height:
                            10), // Memberikan jarak antara teks dan elemen berikutnya
                    Text(item.name ?? 'Not provided',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        )),
                    Text(
                      'Overview',
                      style: TextStyle(
                        color: Color(0xFF22212E),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(item.description ?? 'Not provided'),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Address',
                      style: TextStyle(
                        color: Color(0xFF22212E),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(item.address ?? 'Not provided')
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'About',
                      style: TextStyle(
                        color: Color(0xFF22212E),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    HtmlWidget(
                      item.about ?? 'Not provided',
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (item.profileFile?.url != null &&
                        item.profileFile!.url!.isNotEmpty)
                      Text(
                        'File',
                        style: TextStyle(
                          color: Color(0xFF22212E),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    Row(
                      // Wrap buttons in a Row for horizontal layout
                      mainAxisAlignment: MainAxisAlignment
                          .spaceEvenly, // Space out buttons evenly
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Utils.openPDF(
                                context, item.profileFile!.url.toString());
                          },
                          child: Text('View'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Utils.launchURL(
                                context,
                                item.profileFile!.url
                                    .toString()); // Open URL in web browser
                          },
                          child: Text('Download'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
