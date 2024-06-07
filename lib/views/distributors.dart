import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../models/distributor_response.dart';
import '../utils.dart';
import '../api.dart';
import '../widgets/network_image_global.dart';
import '../app_localzations.dart';

class Distributors extends StatefulWidget {
  @override
  _DistributorState createState() => _DistributorState();
}

class _DistributorState extends State<Distributors> {
  final api = Api();
  late DistributorResponse distributorResponse;
  List<Data> datum = [];
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
      // final response = await http.get(Uri.parse(
      //     '${Const.URL_API}/distributor/lists?page=$page&limit=5&sort=created_at&order=desc&keyword=$keyword'));

      final response = await api.fetchData(context,
          'distributor/lists?page=$page&limit=$limitItem&keyword=$keyword');

      if (response != null) {
        DistributorResponse newResponse =
            DistributorResponse.fromJson(response);

        setState(() {
          if (page == 1) {
            datum = newResponse.data;
          } else {
            datum.addAll(newResponse.data);
          }
          currentPage = page;
          // hasMore = newResponse.data.isNotEmpty;
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
            : Text(AppLocalizations.of(context)!.translate('search_distributor')),
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
                        AppLocalizations.of(context)!.translate('new_distributors'),
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
                                          imageUrl: item?.logo?.url,
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
                                          // Your existing widgets here...
                                          // The Row widget wrapping the Text and PopupMenuButton should now be inside this Column
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                item.name ?? 'Not provided',
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
                                                    <PopupMenuEntry<String>>[
                                                  // const PopupMenuItem<String>(
                                                  //   value: 'edit',
                                                  //   child: Text('Edit'),
                                                  // ),
                                                  // const PopupMenuItem<String>(
                                                  //   value: 'delete',
                                                  //   child: Text('Delete'),
                                                  // ),
                                                ],
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
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 11, 8, 0),
                                            child: Container(
                                              height: 30,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: item
                                                        .distributorCategoryTags
                                                        ?.length ??
                                                    0,
                                                itemBuilder: (context, index) {
                                                  final tag =
                                                      item.distributorCategoryTags?[
                                                          index];
                                                  if (tag == null) {
                                                    return SizedBox.shrink();
                                                  }
                                                  return Container(
                                                    margin: EdgeInsets.only(
                                                        right:
                                                            8), // Add spacing between tags if needed
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12),
                                                    decoration: ShapeDecoration(
                                                      color: Color(0x334894FE),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      tag.name ??
                                                          'Not Provided',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
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
  final Data item;

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
                // title: Text(
                //   item.name ?? 'Not provided',
                //   style: TextStyle(
                //     color: Colors.white, // Changed color to purple
                //   ),
                // ),
                // background: Image.network(
                //   item.logo?.url ?? '',
                //   fit: BoxFit.fitWidth,
                // ),
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
                    Text(
                      item.name ?? 'Not provided',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      'Overview',
                      style: TextStyle(
                        color: Color(0xFF22212E),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(item.overview ?? 'Not provided'),
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
