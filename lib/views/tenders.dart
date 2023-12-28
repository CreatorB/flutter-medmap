import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tender_response.dart';
import '../const.dart';
import '../utils.dart';

class Tenders extends StatefulWidget {
  @override
  _TenderState createState() => _TenderState();
}

class _TenderState extends State<Tenders> {
  late TenderResponse tenderResponse;
  List<TenderData> tenders = [];
  int currentPage = 1;
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
      final response = await http.get(Uri.parse(
          '${Const.URL_API}/tenders?page=$page&limit=5&keyword=$keyword'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        TenderResponse newTenderResponse =
            TenderResponse.fromJson(jsonResponse);

        setState(() {
          if (page == 1) {
            tenders = newTenderResponse.data;
          } else {
            tenders.addAll(newTenderResponse.data);
          }
          currentPage = page;
          // hasMore = newTenderResponse.data.isNotEmpty;
          hasMore = newTenderResponse.data.length == 5;
          isInitialLoad = false;
        });
      } else {
        Utils.showSnackBar(context, 'Failed to load data');
      }
    } catch (e) {
      Utils.showSnackBar(context, e.toString());
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
                  hintText: 'keyword',
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  _updateSearchKeyword(value);
                },
              )
            : Text('Search Tender'),
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
                        'Latest Tenders',
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
                              'Start: ${Utils.formatDateToDMY(tender.openDate)} | Close: ${Utils.formatDateToDMY(tender.closeDate)}',
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
                                      TenderDetailPage(tenderId: tender.id),
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
  final int tenderId;

  TenderDetailPage({required this.tenderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tender Details'),
      ),
      body: Center(
        child: Text('Details for tender ID: $tenderId'),
      ),
    );
  }
}
