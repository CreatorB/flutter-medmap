import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

import '../const.dart';
import '../widgets/slider_images.dart';
import '../views/browse_products.dart';
import '../main.dart';

// void main() {
//   runApp(Products());
// }

// class Products extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MyProducts(),
//     );
//   }
// }

class Products extends StatefulWidget {
  static const String route = '/products';
  Products({
    Key? key,
  }) : super(key: key);
  @override
  _MyProductState createState() => _MyProductState();
}

class _MyProductState extends State<Products> {
  late List<Item> allItems;
  List<Item> displayedItems = [];
  bool isLoading = true;

  final List<Map<String, dynamic>> itemCategories = [
    {
      'image': 'assets/icons/ctg_all.png',
      'title': 'All',
      'color': Color(0xFFE0E0E0),
    },
    {
      'image': 'assets/icons/ctg_medical_equipment.png',
      'title': 'Medical Equipment',
      'color': Color(0xFFF6EFC6),
    },
    {
      'image': 'assets/icons/ctg_medical_consumables.png',
      'title': 'Medical Consumables',
      'color': Color(0xFFFCEEE1),
    },
    {
      'image': 'assets/icons/ctg_molecular_instrument.png',
      'title': 'Molecular Instrument',
      'color': Color(0xFFDAE1FD),
    },
    {
      'image': 'assets/icons/ctg_prescription_drug.png',
      'title': 'Prescription Drug',
      'color': Color(0xFFE3F2E9),
    },
    {
      'image': 'assets/icons/ctg_immunohisto_chemistry.png',
      'title': 'Immunohisto chemistry',
      'color': Color(0xFFFFE7E7),
    },
    {
      'image': 'assets/icons/ctg_imaging_and_diagnostics.png',
      'title': 'Imaging and Diagnostics',
      'color': Color(0xFFFFE7E7),
    },
    {
      'image': 'assets/icons/ctg_laboratory_furniture.png',
      'title': 'Laboratory Furniture',
      'color': Color(0xFFF6EFC6),
    },
    {
      'image': 'assets/icons/ctg_physiotherapy_rehabilitation.png',
      'title': 'Physiotherapy Rehabilitation',
      'color': Color(0xFFE4ECFE),
    },
    {
      'image': 'assets/icons/ctg_software_database.png',
      'title': 'Software & Database',
      'color': Color(0xFFFCEEE1),
    },
    {
      'image': 'assets/icons/ctg_otc_drug.png',
      'title': 'OTC Drug',
      'color': Color(0xFFE4ECFE),
    },
    {
      'image': 'assets/icons/ctg_vaccine.png',
      'title': 'Vaccine',
      'color': Color(0xFFFFE7E7),
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api-medmap.mandatech.co.id/v1/products?page=1&limit=4'));
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
        title: Text('Search Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // NavigationHistory.addContext(context);
              // print("cekCtxProducts : ${context}");
              navbarVisibility(true);
              final back = Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BrowseProducts()),
              );
              if (back == 'back') {
                navbarVisibility(false);
              }
              // showSearch(
              //     context: context,
              //     delegate: ItemSearchDelegate(allItems, searchItems));
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
            : SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                      20, 0, 20, 60.0), // Adds bottom margin of 16.0
                  // height: MediaQuery.of(context)
                  //     .size
                  //     .height, // Set height to screen height
                  // child: SingleChildScrollView(
                  // margin: EdgeInsets.fromLTRB(
                  //     20, 0, 20, 60.0), // Adds bottom margin of 16.0
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
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Latest Products',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      GridView.builder(
                        physics:
                            NeverScrollableScrollPhysics(), // Ensure it doesn't scroll
                        shrinkWrap: true, // Allow it to adapt its size
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
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Categories',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: itemCategories.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              // Handle item tap
                            },
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Card(
                                  elevation: 3,
                                  color: itemCategories[index]['color'],
                                  child: Image.asset(
                                    itemCategories[index]['image']!,
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                    width: 75,
                                    height: 75,
                                  ),
                                ),
                                SizedBox(
                                  width: 89,
                                  height: 36,
                                  child: Text(
                                    itemCategories[index]['title'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF18181B),
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      // height: 0.11,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
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
        close(context, '');
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
            height: 100.0,
            alignment: Alignment.center,
          ),
          SizedBox(height: 8.0),
          Container(
              // child: Text(item.name),
              width: double.infinity, // Match card's width
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
        // title: Text('Another Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, 'back');
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
