import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../const.dart';
import '../main.dart';
import '../widgets/slider_images.dart';

void main() {
  runApp(BrowseProducts());
}

class BrowseProducts extends StatelessWidget {
  static const String route = '/dashboard/browse-products';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyProducts(),
    );
  }
}

class MyProducts extends StatefulWidget {
  @override
  _MyProductState createState() => _MyProductState();
}

class _MyProductState extends State<MyProducts> {
  late List<Item> allItems;
  List<Item> displayedItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api-medmap.mandatech.co.id/v1/products?page=1&limit=999999999'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // Check if the 'items' key exists and is not null
        if (jsonData['data'] != null) {
          final itemsData = jsonData['data'];

          // Check if itemsData is a List
          if (itemsData is List) {
            setState(() {
              allItems = itemsData.map((item) => Item.fromJson(item)).toList();
              displayedItems = List.from(allItems);
              isLoading = false;
            });
          } else {
            print('Invalid data format: data key is not a List');
            setState(() {
              isLoading = false;
            });
          }
        } else {
          print('Key not found: data key is either missing or null');
          setState(() {
            isLoading = false;
          });
        }
        //old
        // setState(() {
        //   allItems = (jsonData['items'] as List)
        //       .map((item) => Item.fromJson(item))
        //       .toList();
        //   displayedItems = List.from(allItems);
        // });
      } else {
        print('Failed to load data. Status Code: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        isLoading = false;
      });
    }
    // final response = await http.get(Uri.parse(
    //     'https://api-medmap.mandatech.co.id/v1/products?page=1&limit=10'));
    // // print("cekAPI: '$response'");
    // // print('Response Body: ${response.body}');
    // // print('Response Code: ${response.statusCode}');
    // if (response.statusCode == 200) {
    //   final jsonData = json.decode(response.body);
    //   setState(() {
    //     allItems = (jsonData['data'] as List)
    //         .map((item) => Item.fromJson(item))
    //         .toList();
    //     // final List<dynamic> jsonList = json.decode(jsonData['data']);
    //   });
    // } else {
    //   throw Exception('Failed to load data');
    // }
  }

  void searchItems(String query) {
    setState(() {
      displayedItems = allItems
          .where(
              (item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.colorDashboard,
        title: Text('Browse Products'),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     BuildContext? previousContext =
        //         NavigationHistory.getPreviousContext();
        //     if (previousContext != null) {
        //       Navigator.pop(
        //           previousContext); // Navigate using the previous context
        //     }
        //     // if (Navigator.canPop(context)) {
        //     // Navigator.pop(context);
        //     // } else {
        //     //   selectTab(0);
        //     //   // Navigator.push(
        //     //   //   context,
        //     //   //   MaterialPageRoute(builder: (context) => MyApp()),
        //     //   // );
        //     // }
        //     // Handle the scenario when there's no route to pop
        //     // }
        //     // Navigator.pop(context, 'back');
        //     // routeTab('/', 0);
        //     print("cekBrowse : ${previousContext}");
        //   },
        // ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: ItemSearchDelegate(allItems, searchItems));
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        // onRefresh method is called when the user pulls down the list
        onRefresh: () async {
          await fetchData();
        },
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                margin: EdgeInsets.fromLTRB(
                    0, 0, 0, 10.0), // Adds bottom margin of 16.0
                // margin: EdgeInsets.all(8.0),
                // padding: EdgeInsets.all(8.0),
                // decoration: BoxDecoration(
                //   border: Border.all(
                //     color: Colors.grey,
                //     width: 1.0,
                //   ),
                //   borderRadius: BorderRadius.circular(8.0),
                // ),
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: displayedItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailProducts(
                                      item: displayedItems[index]),
                                ),
                              );
                            },
                            child: GridItem(item: displayedItems[index]),
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

class ItemSearchDelegate extends SearchDelegate<String> {
  final List<Item> items;
  final Function(String) searchCallback;

  ItemSearchDelegate(this.items, this.searchCallback);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          searchCallback('');
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context, 'back');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    searchCallback(query);
    return Container(); // Results are displayed in the main screen
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(items[index].name),
          onTap: () {
            query = items[index].name;
            searchCallback(query);
            close(context, items[index].name);
          },
        );
      },
    );
  }
}

class GridItem extends StatelessWidget {
  final Item item;

  GridItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            item.url,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 130.0,
            alignment: Alignment.center,
          ),
          SizedBox(height: 8.0),
          Flexible(
              // child: Text(item.name),
              child: Padding(
            padding: const EdgeInsets.all(8.0), // Adjust padding as needed
            child: Text(
              item.name,
              overflow: TextOverflow
                  .ellipsis, // This will cut off extra text with ellipsis
              maxLines: 2, // Limits the number of lines displayed
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

class Item {
  final String name;
  final String url;
  final int id;

  Item({required this.name, required this.url, required this.id});

  factory Item.fromJson(Map<String, dynamic> json) {
    // print("cekJSONItem : '$json'");
    // print(json['thumbnail']['url']);
    return Item(
      name: json['name'],
      url: json['thumbnail']['url'],
      id: json['id'],
    );
  }
}

class DetailProducts extends StatefulWidget {
  final Item item;
  const DetailProducts({required this.item});

  @override
  _DetailProductsState createState() => _DetailProductsState();
}

class _DetailProductsState extends State<DetailProducts> {
  late Future<Map<String, dynamic>> itemDetails;
  late List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    itemDetails = fetchItemDetails(widget.item.id);
  }

  Future<Map<String, dynamic>> fetchItemDetails(int itemId) async {
    final api_products = Const.API_PRODUCTS + '$itemId';
    // final api_products = Const.API_PRODUCTS + 'mc500';
    // print('cekUrl : $api_products');
    final response = await http.get(Uri.parse(api_products));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> images = jsonData['media'];
      setState(() {
        imageUrls = images
            .where((media) => media['type'] == 'image')
            .map((image) => image['url'] as String)
            .toList();
      });
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load item details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Second Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
                context); // This will navigate back to the previous page
          },
        ),
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
                  // Title
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      item['name'],
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
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
