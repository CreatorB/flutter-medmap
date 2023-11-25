import 'package:flutter/material.dart';

class Const {
  static const Color colorSelect = Color(0xFF4894FE);
  static const Color colorUnselect = Color(0xFF8696BB);
  static const Color colorDashboard = Color(0xFFF5EEFA);
  static const String banner = 'assets/icons/medmap_banner.png';
  static const String svgLogo = 'assets/icons/medmap_logo.svg';
  static const String imgMenuTenders = 'assets/images/menu_tenders.png';
  static const String imgMenuDistributors =
      'assets/images/menu_distributors.png';
  static const String imgMenuProducts = 'assets/images/menu_products.png';
  static const String imgMenuRegistrations =
      'assets/images/menu_registrations.png';

  static const String BASE_URL = 'https://api-medmap.mandatech.co.id';
  static const String URL_API = BASE_URL + '/v1/';
  static const String API_PRODUCTS = URL_API + '/products/';
}
