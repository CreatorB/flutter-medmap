import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medmap/cubit/dashboard/dashboard_cubit.dart';
import 'package:medmap/views/auth/login.dart';
import 'package:medmap/views/browse_products.dart';
import 'package:medmap/views/drugs.dart';
import 'package:medmap/views/analysis.dart' as listAnalysis;
import 'package:medmap/views/affair.dart' as listAffair;
import 'package:medmap/views/news.dart' as listNews;
import 'package:medmap/AppLanguage.dart';
import 'package:medmap/app_localzations.dart';
import 'package:medmap/const.dart';
import 'package:medmap/utils.dart';
import 'package:provider/provider.dart';
import 'package:medmap/api.dart';
import 'package:go_router/go_router.dart';
import 'package:medmap/route/app_routes.dart';
import 'package:medmap/main.dart';
import 'package:medmap/models/analysis_response.dart' as analysis;
import 'package:medmap/models/affair_response.dart' as affair;

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late ScrollController _scrollController;
  bool _isScrolledToEnd = false;
  List<analysis.Data> datum = [];
  List<affair.Data> datumAffair = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          setState(() {
            _isScrolledToEnd = true;
          });
        } else {
          setState(() {
            _isScrolledToEnd = false;
          });
        }
      });
    context.read<DashboardCubit>().getAnalysis(context: context);
    context.read<DashboardCubit>().getAffairs(context: context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardCubit(),
      child: Consumer<DashboardCubit>(
        builder: (context, dashboardCubit, child) {
          return Scaffold(
            appBar: AppBar(
              elevation: 2,
              title: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      Const.banner,
                      fit: BoxFit.contain,
                      height: 30,
                    ),
                  ],
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: IconButton(
                    icon: Icon(Icons.perm_identity),
                    onPressed: () async {
                      bool isLoggedIn = await Utils.getSpBool(Const.IS_LOGED_IN) ?? false;
                      if (isLoggedIn) {
                        context.push(AppRoutes.submenu);
                      } else {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
            body: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 60),
              color: Colors.white,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    SearchInputBox(),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircularIconWithTitle(
                          onTap: () {
                            selectTab(1);
                          },
                          iconPath: 'assets/icons/ic_tenders.png',
                          title: AppLocalizations.of(context)!.translate('tenders'),
                          backgroundColor: Color(0xFFDCE3FD),
                          titleColor: Colors.black,
                        ),
                        CircularIconWithTitle(
                          onTap: () {
                            selectTab(3);
                          },
                          iconPath: 'assets/icons/ic_distributors.png',
                          title: AppLocalizations.of(context)!.translate('distributors'),
                          backgroundColor: Color(0xFFFFE7E7),
                          titleColor: Colors.black,
                        ),
                        CircularIconWithTitle(
                          onTap: () {
                            selectTab(2);
                          },
                          iconPath: 'assets/icons/ic_products.png',
                          title: AppLocalizations.of(context)!.translate('products'),
                          backgroundColor: Color(0xFFFCEEE1),
                          titleColor: Colors.black,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircularIconWithTitle(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Drugs()),
                            );
                          },
                          iconPath: 'assets/icons/ic_pharmacy.png',
                          title: AppLocalizations.of(context)!.translate('e_pharmacy'),
                          backgroundColor: Color(0xFFF6EFC6),
                          titleColor: Colors.black,
                        ),
                        CircularIconWithTitle(
                          onTap: () {
                            Utils.openPDFFromAssets(context, 'assets/pdfs/content_service.pdf');
                          },
                          iconPath: 'assets/icons/ic_services.png',
                          title: AppLocalizations.of(context)!.translate('services'),
                          backgroundColor: Color(0xFFE3F3EA),
                          titleColor: Colors.black,
                        ),
                        CircularIconWithTitle(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => listNews.News()),
                            );
                          },
                          iconPath: 'assets/icons/ic_events.png',
                          title: AppLocalizations.of(context)!.translate('events'),
                          backgroundColor: Color(0xFFD3F2FF),
                          titleColor: Colors.black,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                            child: Text(
                              AppLocalizations.of(context)!.translate('breakthrough_case_studies'),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0, top: 16.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => listAnalysis.Analysis()),
                                );
                              },
                              child: Text(
                                'View All',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Inter',
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 300,
                      child: ListView.separated(
                        itemCount: datum.length,
                        itemBuilder: (context, index) {
                          final item = datum[index];
                          return Card(
                            color: Colors.white,
                            margin: EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => listAnalysis.DetailPage(item: item),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (item.image?.url != null)
                                          Image.network(
                                            item.image!.url!,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
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
                        separatorBuilder: (context, index) => SizedBox(height: 0),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              AppLocalizations.of(context)!.translate('medical_policy_affairs'),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => listAffair.Affair()),
                                );
                              },
                              child: Text(
                                'View All',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Inter',
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 300,
                      child: ListView.separated(
                        itemCount: datumAffair.length,
                        itemBuilder: (context, index) {
                          final item = datumAffair[index];
                          return Card(
                            color: Colors.white,
                            margin: EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => listAffair.DetailPage(item: item),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (item.image?.url != null)
                                          Image.network(
                                            item.image!.url!,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
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
                        separatorBuilder: (context, index) => SizedBox(height: 0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: FloatingActionButton(
                onPressed: () {
                  if (_isScrolledToEnd) {
                    _scrollController.animateTo(
                      0,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 500),
                    );
                  } else {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 500),
                    );
                  }
                },
                child: Icon(
                  _isScrolledToEnd ? Icons.arrow_upward : Icons.arrow_downward,
                ),
                tooltip: _isScrolledToEnd ? 'Scroll to Top' : 'Scroll to End',
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
        },
      ),
    );
  }
}

class CircularIconWithTitle extends StatelessWidget {
  final String iconPath;
  final String title;
  final Color backgroundColor;
  final Color titleColor;
  final VoidCallback onTap;

  CircularIconWithTitle({
    required this.iconPath,
    required this.title,
    required this.backgroundColor,
    required this.titleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: backgroundColor,
              child: Image.asset(
                iconPath,
                width: 50,
                height: 50,
              ),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: titleColor,
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchInputBox extends StatefulWidget {
  @override
  _SearchInputBoxState createState() => _SearchInputBoxState();
}

class _SearchInputBoxState extends State<SearchInputBox> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50.0),
          topRight: Radius.circular(50.0),
          bottomLeft: Radius.circular(50.0),
          bottomRight: Radius.circular(50.0),
        ),
        child: TextField(
          controller: _controller,
          onSubmitted: (value) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BrowseProducts(keyword: value)),
            );
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            prefixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                print('Search submitted: ${_controller.text}');
              },
            ),
            hintText: 'Search...',
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}