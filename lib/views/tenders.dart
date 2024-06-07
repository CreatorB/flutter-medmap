import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:medmap/app_localzations.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
import '../models/tender_response.dart';
import '../const.dart';
import '../api.dart';
import '../utils.dart';
import 'package:share_plus/share_plus.dart';
import '../app_localzations.dart';

class Tenders extends StatefulWidget {
  @override
  _TenderState createState() => _TenderState();
}

class _TenderState extends State<Tenders> {
  final api = Api();
  late TenderResponse tenderResponse;
  List<TenderData> tenders = [];
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

  Future<void> fetchData({int page = 1}) async {
    if (!hasMore || isLoading) return;

    setState(() {
      isLoading = true;
      if (page == 1) {
        isInitialLoad = true;
      }
    });

    try {
      final response = await api.fetchData(
          context, 'tenders?page=$page&limit=$limitItem&keyword=$keyword');

      if (response != null) {
        // final Map<String, dynamic> jsonResponse = response.body;
        TenderResponse newTenderResponse = TenderResponse.fromJson(response);

        setState(() {
          if (page == 1) {
            tenders = newTenderResponse.data;
          } else {
            tenders.addAll(newTenderResponse.data);
          }
          currentPage = page;
          hasMore = newTenderResponse.data.isNotEmpty;
          hasMore = newTenderResponse.data.length == limitItem;
          isInitialLoad = false;
        });
      }
    } catch (e) {
      Utils.showSnackBar(context, e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }

    // try {
    //   final response = await http.get(Uri.parse(
    //       '${Const.URL_API}/tenders?page=$page&limit=$limitItem&keyword=$keyword'));

    //   // print('cekResponse: $response');

    //   if (response.statusCode == 200) {
    //     final Map<String, dynamic> jsonResponse = json.decode(response.body);

    //     TenderResponse newTenderResponse =
    //         TenderResponse.fromJson(jsonResponse);

    //     setState(() {
    //       if (page == 1) {
    //         tenders = newTenderResponse.data;
    //       } else {
    //         tenders.addAll(newTenderResponse.data);
    //       }
    //       currentPage = page;
    //       // hasMore = newTenderResponse.data.isNotEmpty;
    //       hasMore = newTenderResponse.data.length == limitItem;
    //       isInitialLoad = false;
    //     });
    //   } else {
    //     Utils.showSnackBar(context, 'Failed to load data');
    //   }
    // } catch (e) {
    //   Utils.showSnackBar(context, e.toString());
    // } finally {
    //   setState(() {
    //     isLoading = false;
    //   });
    // }
  }

  void _updateSearchKeyword(String newKeyword) {
    setState(() {
      keyword = newKeyword;
      currentPage = 1;
      tenders = [];
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
            : Text(AppLocalizations.of(context)!.translate('search_tender')),
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
                        AppLocalizations.of(context)!.translate('latest_tender'),
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
                        itemCount: tenders.length + (hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == tenders.length) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final tender = tenders[index];
                          return ListTile(
                            title: Text(
                              tender.title,
                              style: TextStyle(
                                color: Color(0xFF22212E),
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              'Start  : ${Utils.formatDateToDMY(tender.openDate)}\nClose : ${Utils.formatDateToDMY(tender.closeDate)}\nCountry : ${tender?.state?.country?.name}',
                              style: TextStyle(
                                color: Color(0xFF797979),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TenderDetailPage(item: tender),
                                ),
                              );
                            },
                          );
                        },
                        separatorBuilder: (context, index) =>
                            Divider(height: 1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class TenderDetailPage extends StatelessWidget {
  final TenderData item;

  TenderDetailPage({Key? key, required this.item});

  void _shareProduct() {
    final String productUrl = 'https://med-map.org/tender/detail/${item.id}';
    Share.share(productUrl, subject: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tender Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareProduct,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(8, 0, 8, 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              item.title,
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Avenir',
                  color: Const.primaryTextColor,
                  fontWeight: FontWeight.w900),
              textAlign: TextAlign.left,
            ),
            const Divider(
              color: Colors.black38,
            ),
            Table(
              columnWidths: const {
                0: FractionColumnWidth(0.3), // 30% of the table width for keys
                1: FractionColumnWidth(
                    0.7), // 70% of the table width for values
              },
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Text('Tender Type'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Text(item.tenderType.name,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text('TDR NO'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(item.refNo,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text('Tender Brief'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(item.brief,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text('Competition Type'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(item.state.country.name,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text('State'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(item.state.name,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text('Open Date'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(Utils.formatDateToDMY(item.openDate),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Text(
            //   item.brief,
            //   style: TextStyle(
            //       fontSize: 15,
            //       fontFamily: 'Avenir',
            //       color: Const.primaryTextColor,
            //       fontWeight: FontWeight.w300),
            //   textAlign: TextAlign.left,
            // ),
            const Divider(
              color: Colors.black38,
            ),
            const SizedBox(
              height: 10,
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Tender Detail',
                    style: TextStyle(
                      color: Color(0xFF22212E),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            HtmlWidget(
              item.detail,
            ),
            // SizedBox(
            //   height: 140,
            //   width: MediaQuery.of(context).size.width * 0.95,
            //   child: SingleChildScrollView(
            //     physics: const BouncingScrollPhysics(),
            //     scrollDirection: Axis.vertical,
            //     child: Html(
            //       data: item.detail,
            //       // Optionally set styles for different HTML elements
            //       style: {
            //         "div": Style(
            //           textAlign: TextAlign.center,
            //           color: Colors.black, // Replace with your color constant
            //           fontFamily: 'Avenir',
            //           fontSize: FontSize(20),
            //           fontWeight: FontWeight.w300,
            //         ),
            //         // Add more styles for other tags if needed
            //       },
            //     ),
            //     // child: Text(
            //     //   item.detail,
            //     //   style: TextStyle(
            //     //       fontSize: 20,
            //     //       overflow: TextOverflow.ellipsis,
            //     //       fontFamily: 'Avenir',
            //     //       color: Const.contentTextColor,
            //     //       fontWeight: FontWeight.w400),
            //     //   textAlign: TextAlign.left,
            //     //   maxLines: 60,
            //     // ),
            //   ),
            // ),
            const SizedBox(
              height: 15,
            ),
            const Divider(
              color: Colors.black38,
            ),
            if (item.documentFee?.url != null &&
                item.documentFee!.url!.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  // Utils.launchURL(context, item.documentFee!.url.toString());
                  Utils.openPDF(context, item.documentFee!.url.toString());
                },
                child: Text('View Document Fee'),
              ),
          ],
        ),
      ),
    );
  }
}
