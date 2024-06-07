import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:navbar_router/navbar_router.dart';
import 'dart:async';
import 'dart:developer';

import 'presentation/icon_medmap_home_icons.dart';
import 'const.dart';
import 'views/dashboard.dart';
import 'views/products.dart';
import 'views/tenders.dart';
import 'views/distributors.dart';
import './AppLanguage.dart';
import './app_localzations.dart';
import 'package:provider/provider.dart';

class NavigationHistory {
  static List<BuildContext> _history = [];

  static void addContext(BuildContext context) {
    _history.add(context);
  }

  static BuildContext? getPreviousContext() {
    if (_history.length > 1) {
      // Return the second last context in the history
      return _history[_history.length - 2];
    }
    return null;
  }
}

// void main() {
//   runApp(MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  // runApp(MyApp(
  //   appLanguage: appLanguage,
  // ));
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppLanguage(),
      child: MyApp(appLanguage: appLanguage),
    ),
  );
}

void selectTab(int index) {
  NavbarNotifier.index = index;
}

void routeTab(String route, int index) {
  NavbarNotifier.pushNamed(route, index);
  NavbarNotifier.index = 0;
}

void navbarVisibility(bool status) {
  NavbarNotifier.hideBottomNavBar = status;
  // if (status == true) {
  //   NavbarNotifier.hideBottomNavBar = false;
  //   if (NavbarNotifier.isNavbarHidden) {
  //     NavbarNotifier.hideBottomNavBar = false;
  //   }
  // } else {
  //   NavbarNotifier.hideBottomNavBar = true;
  //   if (NavbarNotifier.isNavbarHidden) {
  //     NavbarNotifier.hideBottomNavBar = true;
  //   }
  // }
}

void changeLang(BuildContext context, String lang) {
  var appLanguage = Provider.of<AppLanguage>(context);
  appLanguage.changeLanguage(Locale(lang));
}

class MyApp extends StatefulWidget {
  final AppLanguage appLanguage;
  MyApp({required this.appLanguage});
  // MyApp({Key? key}) : super(key: key);
  final List<Color> colors = [Colors.white];

  @override
  _MyAppState createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.changeLanguage(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  late AppLocalizations localizations;
  Locale _locale = const Locale('zh');

  void changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
    // debug lang
    _locale = WidgetsBinding.instance.window.locale;
    localizations = AppLocalizations(_locale);
    localizations.load();
  }

// class MyApp extends StatelessWidget {
//   MyApp({Key? key}) : super(key: key);
//   final List<Color> colors = [Colors.white];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: appSetting,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
              debugShowCheckedModeBanner:
                  false, // Set to false to remove the debug banner
              title: 'MEDMAP',
              initialRoute: '/',
              routes: {
                // ProfileEdit.route: (context) => const ProfileEdit(),
                Dashboard.route: (context) => Dashboard(),
                Products.route: (context) => Products(),
                // BrowseProducts.route: (context) => BrowseProducts(),
                // '/products/browse-products': (context) => BrowseProducts(),
              },
              theme: ThemeData(
                colorScheme:
                    ColorScheme.fromSeed(seedColor: Const.colorDashboard),
                useMaterial3: true,
              ),
              // themeMode:
              //     appSetting.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              // darkTheme: ThemeData.dark(
              //   useMaterial3: true,
              // ).copyWith(
              //     colorScheme: ColorScheme.fromSeed(
              //         seedColor: appSetting.themeSeed,
              //         brightness: Brightness.dark)),
              // theme: ThemeData(
              //     useMaterial3: true,
              //     primaryColorDark: appSetting.themeSeed,
              //     colorScheme:
              //         ColorScheme.fromSeed(seedColor: appSetting.themeSeed)),
              // home: const HomePage());
              locale: _locale,
              localizationsDelegates: [
                AppLocalizations
                    .delegate, // Add this line to use AppLocalizations
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                const Locale('en', 'US'), // English
                const Locale('id', 'ID'), // Indo
                const Locale('zh', ''), // Chinese
                // Add other supported locales here
              ],
              home: HomePage());
        });
    // home: const NavbarSample(title: 'BottomNavbar Demo'));
  }
}

AppSetting appSetting = AppSetting();
final List<Color> themeColorSeed = [
  Colors.blue,
  Colors.red,
  Colors.green,
  Colors.purple,
  Colors.orange,
  Colors.teal,
  Colors.pink,
  Colors.indigo,
  Colors.brown,
  Colors.cyan,
  Colors.deepOrange,
  Colors.deepPurple,
  Colors.lime,
  Colors.amber,
  Colors.lightBlue,
  Colors.lightGreen,
  Colors.yellow,
  Colors.grey,
];

class AppSetting extends ChangeNotifier {
  bool isDarkMode;
  Color themeSeed = Colors.blue;

  AppSetting({this.isDarkMode = false});

  void changeThemeSeed(Color color) {
    themeSeed = color;
    notifyListeners();
  }

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  bool _resumedFromBackground = false;

  List<NavbarItem> items = [];

  final Map<int, Map<String, Widget>> _routes = {
    0: {
      '/': Dashboard(),
      // BrowseProducts.route: BrowseProducts(),
    },
    1: {
      '/': Tenders(),
    },
    2: {
      '/': Products(),
      // '/products/browse-products': BrowseProducts(),
      // BrowseProducts.route: BrowseProducts(),
    },
    3: {
      '/': Distributors(),
    },
  };

  DateTime oldTime = DateTime.now();
  DateTime newTime = DateTime.now();

  /// This is only for demo purposes
  void simulateTabChange() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      for (int i = 0; i < items.length * 2; i++) {
        NavbarNotifier.index = i % items.length;
        await Future.delayed(const Duration(milliseconds: 1000));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // simulateTabChange();
    NavbarNotifier.addIndexChangeListener((x) {
      log('NavbarNotifier.indexChangeListener: $x');
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeNavbarItems();
  }

  void initializeNavbarItems() {
    // final localizations = AppLocalizations.of(context);
    items = [
      NavbarItem(
          IconMedmap.home, AppLocalizations.of(context)!.translate('tab_home')),
      // NavbarItem(IconMedmap.home, 'Home'),
      NavbarItem(IconMedmap.tenders,
          AppLocalizations.of(context)!.translate('tab_tenders')),
      NavbarItem(IconMedmap.products,
          AppLocalizations.of(context)!.translate('tab_products')),
      NavbarItem(IconMedmap.distributors,
          AppLocalizations.of(context)!.translate('tab_distributors')),
    ];
  }

  @override
  void dispose() {
    NavbarNotifier.clear();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _resumedFromBackground = true;
      // Add your logic here for what needs to happen when the app resumes.
      print("onResume");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        // print("onBack");
        navbarVisibility(false);
        if (_resumedFromBackground) {
          _resumedFromBackground = false;
          // Add your logic here for handling back after app resumes
          return false; // Return true to allow normal back button behavior, return false to prevent it
        } else {
          // Normal back button behavior
          return true;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: AnimatedBuilder(
            animation: NavbarNotifier(),
            builder: (context, child) {
              if (NavbarNotifier.currentIndex < 1) {
                return Padding(
                  padding: EdgeInsets.only(bottom: kNavbarHeight),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 100,
                      ),
                      // FloatingActionButton.extended(
                      //   heroTag: 'showSnackBar',
                      //   onPressed: () {
                      //     final state = Scaffold.of(context);
                      //     NavbarNotifier.showSnackBar(
                      //       context,
                      //       "This is shown on top of the Floating Action Button",
                      //       bottom:
                      //           state.hasFloatingActionButton ? 0 : kNavbarHeight,
                      //     );
                      //   },
                      //   label: const Text("Show SnackBar"),
                      // ),
                      // FloatingActionButton(
                      //   heroTag: 'navbar',
                      //   child: Icon(NavbarNotifier.isNavbarHidden
                      //       ? Icons.toggle_off
                      //       : Icons.toggle_on),
                      //   onPressed: () {
                      //     // Programmatically toggle the Navbar visibility
                      //     if (NavbarNotifier.isNavbarHidden) {
                      //       NavbarNotifier.hideBottomNavBar = false;
                      //     } else {
                      //       NavbarNotifier.hideBottomNavBar = true;
                      //     }
                      //     setState(() {});
                      //   },
                      // ),
                      // FloatingActionButton(
                      //   heroTag: 'darkmode',
                      //   child: Icon(appSetting.isDarkMode
                      //       ? Icons.wb_sunny
                      //       : Icons.nightlight_round),
                      //   onPressed: () {
                      //     appSetting.toggleTheme();
                      //     setState(() {});
                      //   },
                      // ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
        body: NavbarRouter(
          errorBuilder: (context) {
            return const Center(child: Text('Error 404'));
          },
          isDesktop: size.width > 600 ? true : false,
          onBackButtonPressed: (isExitingApp) {
            if (isExitingApp) {
              newTime = DateTime.now();
              int difference = newTime.difference(oldTime).inMilliseconds;
              oldTime = newTime;
              if (difference < 1000) {
                NavbarNotifier.hideSnackBar(context);
                return isExitingApp;
              } else {
                final state = Scaffold.of(context);
                NavbarNotifier.showSnackBar(
                  context,
                  "Tap back button again to exit",
                  bottom: state.hasFloatingActionButton ? 0 : kNavbarHeight,
                );
                return false;
              }
            } else {
              return isExitingApp;
            }
          },
          initialIndex: 0,
          // type: NavbarType.floating,
          destinationAnimationCurve: Curves.fastOutSlowIn,
          destinationAnimationDuration: 600,
          decoration: NavbarDecoration(
            navbarType: BottomNavigationBarType.fixed,
            indicatorColor: Const.colorSelect,
            backgroundColor: Colors.white,
            selectedIconColor: Const.colorSelect,
            unselectedItemColor: Const.colorUnselect,
          ),
          // decoration: M3NavbarDecoration(
          //   height: 80,
          //   isExtended: size.width > 800 ? true : false,
          //   // labelTextStyle: const TextStyle(
          //   //     color: Color.fromARGB(255, 176, 207, 233), fontSize: 14),
          //   elevation: 3.0,
          //   // indicatorShape: const RoundedRectangleBorder(
          //   //   borderRadius: BorderRadius.all(Radius.circular(20)),
          //   // ),
          //   // indicatorColor: const Color.fromARGB(255, 176, 207, 233),
          //   // // iconTheme: const IconThemeData(color: Colors.indigo),
          //   // /// labelTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
          //   // labelBehavior: NavigationDestinationLabelBehavior.alwaysShow
          // ),
          onChanged: (x) {},
          backButtonBehavior: BackButtonBehavior.rememberHistory,
          destinations: [
            for (int i = 0; i < items.length; i++)
              DestinationRouter(
                navbarItem: items[i],
                destinations: [
                  for (int j = 0; j < _routes[i]!.keys.length; j++)
                    Destination(
                      route: _routes[i]!.keys.elementAt(j),
                      widget: _routes[i]!.values.elementAt(j),
                    ),
                ],
                initialRoute: _routes[i]!.keys.first,
              ),
          ],
        ),
      ),
    );
  }
}
