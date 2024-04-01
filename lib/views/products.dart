import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

import '../views/browse_products.dart' as browse_products;
import '../main.dart';
import '../views/details/detail_products.dart';

class Products extends StatefulWidget {
  static const String route = '/products';
  Products({
    Key? key,
  }) : super(key: key);
  @override
  _MyProductState createState() => _MyProductState();
}

class _MyProductState extends State<Products> {
  late List<Item?> allItems = [];
  List<Item> displayedItems = [];
  bool isLoading = true;

  final List<Map<String, dynamic>> itemCategories = [
    {
      'image': 'assets/icons/ctg_all.png',
      'title': 'All',
      'color': Color(0xFFE0E0E0),
      'id': '',
    },
    {
      'image': 'assets/icons/ctg_medical_equipment.png',
      'title': 'Medical Equipment',
      'color': Color(0xFFF6EFC6),
      'id': '1',
    },
    {
      'image': 'assets/icons/ctg_medical_consumables.png',
      'title': 'Medical Consumables',
      'color': Color(0xFFFCEEE1),
      'id': '2',
    },
    {
      'image': 'assets/icons/ctg_molecular_instrument.png',
      'title': 'Molecular Instrument',
      'color': Color(0xFFDAE1FD),
      'id': '3',
    },
    // {
    //   'image': 'assets/icons/ctg_prescription_drug.png',
    //   'title': 'Prescription Drug',
    //   'color': Color(0xFFE3F2E9),
    //   'id': '9',
    // },
    {
      'image': 'assets/icons/ctg_immunohisto_chemistry.png',
      'title': 'Immunohisto chemistry',
      'color': Color(0xFFFFE7E7),
      'id': '4',
    },
    {
      'image': 'assets/icons/ctg_imaging_and_diagnostics.png',
      'title': 'Imaging and Diagnostics',
      'color': Color(0xFFFFE7E7),
      'id': '5',
    },
    {
      'image': 'assets/icons/ctg_laboratory_furniture.png',
      'title': 'Laboratory Furniture',
      'color': Color(0xFFF6EFC6),
      'id': '7',
    },
    {
      'image': 'assets/icons/ctg_physiotherapy_rehabilitation.png',
      'title': 'Physiotherapy Rehabilitation',
      'color': Color(0xFFE4ECFE),
      'id': '6',
    },
    {
      'image': 'assets/icons/ctg_software_database.png',
      'title': 'Software & Database',
      'color': Color(0xFFFCEEE1),
      'id': '8',
    },
    // {
    //   'image': 'assets/icons/ctg_otc_drug.png',
    //   'title': 'OTC Drug',
    //   'color': Color(0xFFE4ECFE),
    //   'id': '10',
    // },
    // {
    //   'image': 'assets/icons/ctg_vaccine.png',
    //   'title': 'Vaccine',
    //   'color': Color(0xFFFFE7E7),
    //   'id': '11',
    // },
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
      print("cekProductResponse : " + response.body);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData.containsKey('data') && jsonData['data'] != null) {
          final itemsData = jsonData['data'];
          if (itemsData is List) {
            setState(() {
              allItems = itemsData
                  .map((item) {
                    if (item == null || item is! Map<String, dynamic>) {
                      print('Skipping item due to null or incorrect type');
                      return null;
                    }
                    return Item.fromJson(item);
                  })
                  .where((item) => item != null)
                  .toList()
                  .cast<Item>();
              displayedItems = List.from(allItems);
              isLoading = false;
              // print('All Items: $allItems');
              // print('Displayed Items: $displayedItems');
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
  }

  void searchItems(String query) {
    setState(() {
      // Use the null-aware operator to safely access the 'name' property
      displayedItems = allItems
          .where((item) =>
              item?.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .map((item) =>
              item!) // This is safe now because we've filtered out nulls
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
                MaterialPageRoute(
                    builder: (context) => browse_products.BrowseProducts()),
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
                      20, 0, 20, 100.0), // Adds bottom margin of 16.0
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
                          mainAxisSpacing: 20,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              // Handle item tap
                              if (itemCategories[index]['id'] == '0') {
                                // navbarVisibility(true);
                                final back = Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          browse_products.BrowseProducts()),
                                );
                                // if (back == 'back') {
                                //   navbarVisibility(false);
                                // }
                              } else {
                                // navbarVisibility(true);
                                final back = Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          browse_products.BrowseProducts(
                                              title: itemCategories[index]
                                                  ['title'],
                                              categoryId: itemCategories[index]
                                                  ['id'])),
                                );
                                // if (back == 'back') {
                                //   navbarVisibility(false);
                                // }
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.stretch,
                                // mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Card(
                                    elevation: 0,
                                    color: itemCategories[index]['color'],
                                    child: Image.asset(
                                      itemCategories[index]['image']!,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                      width: 75,
                                      height: 75,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Expanded(
                                    child: Text(
                                      itemCategories[index]['title'],
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                        color: Color(0xFF18181B),
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        // height: 0.11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
          title: Text(items[index].name ?? 'Null'),
          onTap: () {
            query = items[index].name ?? "";
            searchCallback(query);
            close(context, items[index].name ?? "");
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
      elevation: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            item.url!,
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
                  item.name!,
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

// class Tag {
//   int id;
//   String name;
//   DateTime createdAt;
//   DateTime updatedAt;

//   Tag({
//     required this.id,
//     required this.name,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory Tag.fromJson(Map<String, dynamic> json) => Tag(
//         id: json['id'],
//         name: json['name'],
//         createdAt: DateTime.parse(json['created_at']),
//         updatedAt: DateTime.parse(json['updated_at']),
//       );
// }

// end model
