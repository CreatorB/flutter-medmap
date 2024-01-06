import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
// import 'package:portfolio/application/theme/config.dart';
import 'package:http/http.dart' as http;

import '../const.dart';

class Products extends StatefulWidget {
  @override
  _MyProducts createState() => _MyProducts();
}

class _MyProducts extends State<Products> {
  ApiProvider apiProvider = ApiProvider();

  @override
  void initState() {
    super.initState();

    getMediumData();
  }

  late bool isLoading = false;
  late String searchTerm;
  late String title;
  //List<MediumWidget> todoWidgets = [];
  TextEditingController editingController = TextEditingController();
  late String descrip;
  late int length;
  List<dynamic> itemsList = [];
  var mediumData;
  late String imageUrl;

  Future getMediumData() async {
    mediumData = await apiProvider.getBlogs();
    title = mediumData['feed']['title'];
    imageUrl = mediumData['items'][0]['thumbnail'];
    isLoading = true;
    print(imageUrl);
    setState(() {
      itemsList = mediumData['items'];
    });
  }

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.lightBlueAccent,
        ),
      );
    }
    return Scaffold(
        // backgroundColor: Colors.black,
        // backgroundColor: Const.colorDashboard,
        body: SafeArea(
            child: Container(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: (value) {
            setState(() {
              searchTerm = value;
            });
          },
          controller: editingController,
          decoration: InputDecoration(
              // labelText: "Search",
              hintText: "Search",
              fillColor: Const.colorDashboard,
              filled: true,
              prefixIcon: Icon(Icons.search),
              border: UnderlineInputBorder(
                  // borderRadius: BorderRadius.only(
                  //     bottomLeft: Radius.elliptical(10, 10))
                  )),
        ),
      ),
      Expanded(
        child: Container(
          child: GridView.extent(
              shrinkWrap: true,
              maxCrossAxisExtent: 400,
              children: [
                for (int i = 0; i < itemsList.length; i++)
                  if (mediumData['items'][i]['title']
                      .toLowerCase()
                      .contains(editingController.text))
                    InkWell(
                      onTap: () {
                        _launchURL(mediumData['items'][i]['link']);
                      },
                      child: ListViewItems(
                        author: mediumData['items'][i]['author'],
                        imageUrl: mediumData['items'][i]['thumbnail'],
                        title: mediumData['items'][i]['title'],
                      ),
                    )
              ]),
        ),
      ),
    ]))));
  }
}

class ListViewItems extends StatelessWidget {
  const ListViewItems(
      {required this.imageUrl, required this.author, required this.title});

  final String imageUrl;
  final String author;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20.0),
      child: Container(
        padding: EdgeInsets.all(0.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.network(
              imageUrl,
              height: 200,
            ),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              width: 500,
              height: 70,
              child: Container(
                padding: EdgeInsets.all(2.0),
                // color: Colors.grey[600],
                color: Colors.white,
                child: Column(
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF18181B),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 0.11,
                      ),
                    ),
                    // Expanded(
                    //   child: Text(
                    //     title,
                    //     style: TextStyle(
                    //       color: Colors.black,
                    //       fontSize: 20.0,
                    //     ),
                    //   ),
                    // ),
                    // Text(
                    //   author,
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 10.0,
                    //   ),
                    // ),
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

/// change the yourusername with your medium username
const BLOG_API =
    'https://api.rss2json.com/v1/api.json?rss_url=https://medium.com/feed/@mercyjemosop';

class ApiProvider {
  Future getBlogs() async {
    final response = await http.get(Uri.parse(
        'https://api.rss2json.com/v1/api.json?rss_url=https://medium.com/feed/@mercyjemosop'));
    if (response.statusCode == 200) {
      var data = response.body;
      return jsonDecode(data);
    } else {
      return response.statusCode;
    }
  }
}
