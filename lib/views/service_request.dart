import 'dart:convert';

import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:medmap/models/service_request_response.dart' as service_request;
import '../utils.dart';
import '../api.dart';

class ServiceRequest extends StatefulWidget {
  @override
  _ServiceRequestState createState() => _ServiceRequestState();
}

class _ServiceRequestState extends State<ServiceRequest> {
  final api = Api();
  late service_request.ServiceRequestResponse modelResponse;
  List<service_request.Data> datum = [];
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
      final response = await api.fetchData(context,
          'service-requests?sort=created_at&order=desc&page=$page&limit=$limitItem&keyword=$keyword');
      if (response != null) {
        modelResponse = service_request.ServiceRequestResponse.fromJson(response);

        setState(() {
          if (page == 1) {
            datum = modelResponse.data ?? [];
          } else {
            datum.addAll(modelResponse.data ?? []);
          }
          currentPage = page;
          hasMore = modelResponse.data?.length == limitItem;
          isInitialLoad = false;
        });
      } else {
        Utils.showSnackBar(
            context, 'Failed to load data : ' + response.toString());
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
            : Text('Search Item'),
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
                        'Service Request List',
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
                                        ServiceRequestDetailPage(item: item),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start, // Align items vertically at the start
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 10),
                                              Text(
                                                Utils.fmtToDMY(item.createdAt),
                                                style: TextStyle(
                                                  color: Color(0xFF514A6B),
                                                  fontSize: 12,
                                                  fontFamily: 'Open Sans',
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
                                                ),
                                              ),
                                              Text(
                                                Utils.trimString(item.title),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  color: Color(0xFF150A33),
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                'Read More',
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 11,
                                                  fontFamily: 'Open Sans',
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
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

class ServiceRequestDetailPage extends StatefulWidget {
  final service_request.Data item;
  ServiceRequestDetailPage({Key? key, required this.item});

  @override
  _ServiceRequestDetailPageState createState() => _ServiceRequestDetailPageState();
}

class _ServiceRequestDetailPageState extends State<ServiceRequestDetailPage> {
  late FleatherController _controller;

  @override
  void initState() {
    super.initState();
    final description = widget.item.description != null
        ? jsonDecode(widget.item.description!) as List<dynamic>
        : [];

    final document = ParchmentDocument.fromJson(description);

    _controller = FleatherController(document: document);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Request Details'),
      ),
      body: Container(
        margin: EdgeInsets.only(bottom: 60), // Tambahkan margin bawah sebesar 60
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.item.title ?? 'Title not provided',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Created At: ${Utils.fmtToDMY(widget.item.createdAt)}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Price : ${widget.item.budget.toString()} ${widget.item.currency!} ${" | " + widget.item.priceType!}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Description:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              FleatherEditor(
                controller: _controller,
                focusNode: FocusNode(),
                embedBuilder: (context, node) {
                  if (node.value.type == 'image') {
                    final data = node.value.data;
                    String? imageUrl;
                    imageUrl = data['source'] as String?;
                    if (imageUrl != null) {
                      return Image.network(widget.item.image!.url!);
                    } else {
                      return Text('Invalid image data');
                    }
                  }
                  return Text('Unsupported embed type: ${node.value.type}');
                },
              ),
              SizedBox(height: 20),
              Text(
                'Submitter : ${widget.item.submitter!.username! + " | " + widget.item.submitter!.email!}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}