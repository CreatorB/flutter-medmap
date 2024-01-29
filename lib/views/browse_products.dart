import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/product_response.dart';

import '../widgets/slider_images.dart';
import '../widgets/network_image_local_fallback.dart';
import '../api.dart';
import '../utils.dart';

class BrowseProducts extends StatefulWidget {
  static const String route = '/dashboard/browse-products';
  final String? title;
  final String? categoryId;

  BrowseProducts({Key? key, this.title, this.categoryId}) : super(key: key);

  @override
  _MyProductState createState() => _MyProductState();
}

class _MyProductState extends State<BrowseProducts> {
  final api = Api();
  late ProductResponse productResponse;
  List<Datum> products = [];
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

  // void _onScroll() {
  //   final maxScroll = _scrollController.position.maxScrollExtent;
  //   final currentScroll = _scrollController.position.pixels;
  //   if (currentScroll == maxScroll && hasMore && !isLoading) {
  //     print('Reached bottom of the list. Fetching more data...');
  //     fetchData(page: currentPage + 1);
  //   }
  // }

  // void _onScroll() {
  // final maxScroll = _scrollController.position.maxScrollExtent;
  // final currentScroll = _scrollController.position.pixels;
  // const double threshold = 10; // Adjust the threshold as needed
  // if (currentScroll >= maxScroll - threshold && hasMore && !isLoading) {
  // print('Reached bottom of the list. Fetching more data...');
  // setState(() {
  //   isLoading = true;
  // });
  // fetchData(page: currentPage + 1);
  // }
  // }

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
          'products?page=$page&limit=$limitItem&keyword=$keyword&category_ids=${widget.categoryId ?? ""}');
      if (response != null) {
        ProductResponse newProductResponse = ProductResponse.fromJson(response);

        setState(() {
          if (page == 1) {
            // products = newProductResponse.data ?? [];
            products.clear();
          }
          products.addAll(newProductResponse.data ?? []);
          currentPage = page;
          // hasMore = newProductResponse.data!.isNotEmpty;
          hasMore = newProductResponse.data?.length == limitItem;
          isLoading = false;
          isInitialLoad = false;
        });
      }
    } catch (error) {
      print('failed fetch product : $error');
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

  void _updateSearchKeyword(String newKeyword) {
    setState(() {
      keyword = newKeyword;
      currentPage = 1;
      products = [];
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
            : Text(widget.title ?? 'All Products'),
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
          : products.isEmpty
              ? Center(child: Text('No data available'))
              : RefreshIndicator(
                  onRefresh: () => fetchData(page: 1),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                        0, 0, 0, 60.0), // Adds bottom margin of 16.0
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
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailProducts(item: products[index]),
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
                ),
      // body: isLoading
      //     ? Center(child: CircularProgressIndicator())
      //     : Container(
      //         margin: EdgeInsets.fromLTRB(
      //             0, 0, 0, 60.0), // Adds bottom margin of 16.0
      //         // margin: EdgeInsets.all(8.0),
      //         // padding: EdgeInsets.all(8.0),
      //         // decoration: BoxDecoration(
      //         //   border: Border.all(
      //         //     color: Colors.grey,
      //         //     width: 1.0,
      //         //   ),
      //         //   borderRadius: BorderRadius.circular(8.0),
      //         // ),
      //         child: Column(
      //           children: [
      //             Expanded(
      //               child: GridView.builder(
      //                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //                   crossAxisCount: 2,
      //                   crossAxisSpacing: 8.0,
      //                   mainAxisSpacing: 8.0,
      //                 ),
      //                 itemCount: displayedItems.length,
      //                 itemBuilder: (BuildContext context, int index) {
      //                   return GridItem(item: displayedItems[index]);
      //                 },
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
    );
  }
}

class GridItem extends StatelessWidget {
  final Datum item;

  GridItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NetworkImageWithLocalFallback(
            imageUrl: item.thumbnail?.url ?? '',
            localAsset: 'assets/images/no_img.jpg',
          ),
          // Image.network(
          //   item.thumbnail?.url ?? 'assets/images/no_img.jpg',
          //   fit: BoxFit.cover,
          //   width: double.infinity,
          //   height: 130.0,
          //   alignment: Alignment.center,
          // ),
          SizedBox(height: 8.0),
          Container(
              // child: Text(item.name),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0), // Adjust padding as needed
                child: Text(
                  item.name ?? 'Not provided',
                  overflow: TextOverflow
                      .ellipsis, // This will cut off extra text with ellipsis
                  maxLines: 1, // Limits the number of lines displayed
                  // style: TextStyle(fontSize: 16.0), // Adjust font size as needed
                  style: TextStyle(
                    color: Color(0xFF18181B),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    // height: 0.11,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class DetailProducts extends StatefulWidget {
  final Datum item;
  const DetailProducts({required this.item});

  @override
  _DetailProductsState createState() => _DetailProductsState();
}

class _DetailProductsState extends State<DetailProducts> {
  late Future<Map<String, dynamic>> itemDetails;
  late List<String> imageUrls = [];
  final api = Api();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    itemDetails = fetchItemDetails(widget.item.id);
  }

  Future<Map<String, dynamic>> fetchItemDetails(int itemId) async {
    try {
      final response = await api.fetchData(context, 'products/$itemId');
      if (response != null) {
        final List<dynamic> images = response['media'];
        setState(() {
          imageUrls = images
              .where((media) => media['type'] == 'image')
              .map((image) => image['url'] as String)
              .toList();
        });
        return response;
      } else {
        throw Exception('Failed to load item details');
      }
    } catch (e) {
      throw Exception('Error : $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _shareProduct() {
    final String productUrl =
        'https://med-map.org/product-detail/${widget.item.slug}';
    Share.share(productUrl, subject: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Second Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareProduct,
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: itemDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            final item = snapshot.data!;
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.fromLTRB(
                    0, 0, 0, 60.0), // Adds bottom margin of 16.0
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Slider
                    // SliderImages(
                    //   images: [
                    //     'https://api-medmap.mandatech.co.id/uploads/product-media/cl2vb1bl8005a0lp0a8sc0qv0.jpg',
                    //     'https://api-medmap.mandatech.co.id/uploads/product-media/cl2vb1jh6005c0lp070mo6xlf.jpg',
                    //   ],
                    // ),
                    SliderImages(images: imageUrls),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 11, 8, 0),
                      child: Container(
                        height: 30,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: ShapeDecoration(
                          color: Color(0x334894FE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: (item['tags'] as List<dynamic>).map((tag) {
                            // children: (item.tags as List<dynamic>).map((tag) {
                            // return Chip(
                            //   label: Text(tag['name']),
                            //   backgroundColor: Colors.blue,
                            //   labelStyle: TextStyle(color: Colors.white),
                            // );
                            return Text(
                              tag['name'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            );
                          }).toList(),
                          // children: [
                          //   Text(
                          //     item.tags[0].name,
                          //     style: TextStyle(
                          //       color: Colors.black,
                          //       fontSize: 14,
                          //       fontFamily: 'Inter',
                          //       fontWeight: FontWeight.w400,
                          //       height: 0,
                          //     ),
                          //   ),
                          // ],
                        ),
                      ),
                    ),
                    // Title
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item['name'],
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: SizedBox(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Category: ',
                                style: TextStyle(
                                  color: Color(0xFF757575),
                                  fontSize: 13,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: item['category']['name'],
                                style: TextStyle(
                                  color: Color(0xFF757575),
                                  fontSize: 13,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: SizedBox(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: item['manufacturer'] != null
                                    ? 'Manufacturer: '
                                    : 'Distributor: ',
                                style: TextStyle(
                                  color: Color(0xFF757575),
                                  fontSize: 13,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: item['manufacturer'] != null
                                    ? item['manufacturer']['name']
                                    : item['distributor']['name'],
                                style: TextStyle(
                                  color: Color(0xFF4894FE),
                                  fontSize: 13,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 13),
                      child: SizedBox(
                        // width: 334,
                        // height: 244,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Product Details\n',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.15,
                                ),
                              ),
                              TextSpan(
                                text: item['description'],
                                style: TextStyle(
                                  color: Color(0xFF757575),
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
            // return Center(
            //   child: Text(
            //     'Details of Item ${item['id']}: ${item['name']}',
            //     style: TextStyle(fontSize: 24),
            //   ),
            // );
          }
        },
      ),
    );
  }
}
