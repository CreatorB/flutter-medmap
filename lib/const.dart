import 'package:flutter/material.dart';

class Const {
  static const String URL_WEB = 'https://med-map.org';
  static const String URL_WEB_DETAIL_CASE = URL_WEB + '/cases-analysis/detail';
  static const String URL_WEB_DETAIL_PRODUCT = URL_WEB + '/product-detail';
  static const String BASE_URL = 'https://api.med-map.org';
  // static const String BASE_URL = 'https://api-medmap.mandatech.co.id';
  // static const String BASE_URL = 'https://be-mdmap.mandatech.co.id/';
  static const String URL_API = BASE_URL + '/v1';
  static const String API_PRODUCTS = URL_API + '/products/';
  static const String API_LOGIN = URL_API + '/auth/login';
  static const String API_REGISTER = URL_API + '/auth/register/';

  static const String URL_PRIVACY = URL_WEB + '/privacy-policy';
  
  static const String IS_LOGED_IN = 'is_logged_in';
  static const String TOKEN = 'token';
  static const String EXPIRES_AT = 'expires_at';
  static const String USERNAME = 'username';
  static const String NAME = 'name';
  static const String OBJ_PROFILE = 'obj_profile';

  static const Color primaryBlue = Color(0xFF4894FE);
  static const Color primaryTextColor = Color(0xFF414C6B);
  static const Color secondaryTextColor = Color(0xFFE4979E);
  static const Color titleTextColor = Colors.white;
  static const Color contentTextColor = Color(0xff868686);
  static const Color navigationColor = Color(0xFF6751B5);
  static const Color gradientStartColor = Color(0xFF0050AC);
  static const Color gradientEndColor = Color(0xFF9354B9);
  static const Color colorSelect = Color(0xFF4894FE);
  static const Color colorUnselect = Color(0xFF8696BB);
  static const Color colorDashboard = Color(0xFFF5EEFA);
  static const String submenu_report = 'assets/icons/submenu_report.png';
  static const String submenu_event = 'assets/icons/submenu_event.png';
  static const String submenu_design = 'assets/icons/submenu_design.png';
  static const String submenu_privacy = 'assets/icons/submenu_privacy.png';
  static const String banner = 'assets/icons/medmap_banner.png';
  static const String svgLogo = 'assets/icons/medmap_logo.svg';
  static const String imgMenuTenders = 'assets/images/menu_tenders.png';
  static const String imgMenuDistributors =
      'assets/images/menu_distributors.png';
  static const String imgMenuProducts = 'assets/images/menu_products.png';
  static const String imgMenuRegistrations =
      'assets/images/menu_registrations.png';
  static const String imgMenuDrugs = 'assets/images/menu_phar.png';
  static const String imgMenuServices = 'assets/images/menu_services.png';
}
