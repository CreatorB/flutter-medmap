import '../../models/product.dart';
import '../../const.dart';
import '../../widgets/slider_images.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

//start model
class Item {
  final String name;
  final String url;
  final int id;
  List<Tag> tags;
  Manufacturer? manufacturer;

  Item({
    required this.name,
    required this.url,
    required this.id,
    required this.tags,
    this.manufacturer,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    // print("cekJSONItem : '$json'");
    // print(json['thumbnail']['url']);
    return Item(
      name: json['name'],
      url: json['thumbnail']['url'],
      id: json['id'],
      tags: List<Tag>.from(json['tags'].map((x) => Tag.fromJson(x))),
      manufacturer: json['manufacturer'] != null
          ? Manufacturer.fromJson(json['manufacturer'])
          : null,
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
  late Future<Product> itemDetails;
  late List<String> imageUrls = [];
  @override
  void initState() {
    super.initState();
    itemDetails = fetchItemDetails(widget.item.id);
  }

  Future<Product> fetchItemDetails(int itemId) async {
    final api_products = Const.API_PRODUCTS + '$itemId';
    // final api_products = Const.API_PRODUCTS + 'mc500';
    // print('cekUrl : $api_products');
    final response = await http.get(Uri.parse(api_products));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      // Map<String, dynamic> jsonMap = jsonData;
      // data = ProductDetails.fromJson(jsonData);
      // print('Product Name: ${data.name}');

      final List<dynamic> images = jsonData['media'];
      setState(() {
        imageUrls = images
            .where((media) => media['type'] == 'image')
            .map((image) => image['url'] as String)
            .toList();
      });
      // return json.decode(response.body);
      return Product.fromJson(jsonDecode(response.body));
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
      body: FutureBuilder<Product>(
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                      // Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: 4.0),
                      //   child: Wrap(
                      //     spacing: 8.0,
                      //     children: (item['tags'] as List<dynamic>).map((tag) {
                      //       return Chip(
                      //         label: Text(tag['name']),
                      //         backgroundColor: Colors.blue,
                      //         labelStyle: TextStyle(color: Colors.white),
                      //       );
                      //     }).toList(),
                      //   ),
                      // ),
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
                            children: (item.tags).map((tag) {
                              // children: (item.tags as List<dynamic>).map((tag) {
                              // return Chip(
                              //   label: Text(tag['name']),
                              //   backgroundColor: Colors.blue,
                              //   labelStyle: TextStyle(color: Colors.white),
                              // );
                              return Text(
                                tag.name,
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
                          item.name,
                          style: TextStyle(
                            color: Color(0xFF18181B),
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
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
                                  text: 'Category: ',
                                  style: TextStyle(
                                    color: Color(0xFF757575),
                                    fontSize: 13,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(
                                  text: item.category.name,
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
                                  text: item.manufacturer != null
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
                                  text: item.manufacturer != null
                                      ? item.manufacturer?.name
                                      : item.distributor?.name,
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
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
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
                                  text: item.description,
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
