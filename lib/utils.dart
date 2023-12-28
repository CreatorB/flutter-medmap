import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class Utils {
  static String formatDateToDMY(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date).toString();
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
