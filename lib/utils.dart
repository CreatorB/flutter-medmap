import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:flutter/services.dart';
import 'views/pdf_screen.dart';
import 'package:share_plus/share_plus.dart';

class Utils {
  // static void myLog(String message) {
  //   final pattern = RegExp('.{1,800}');
  //   pattern.allMatches(message).forEach((match) => print(match.group(0)));
  // }

  static void myLog(Object object) async {
    int defaultPrintLength = 1020;
    if (object == null || object.toString().length <= defaultPrintLength) {
      print(object);
    } else {
      String log = object.toString();
      int start = 0;
      int endIndex = defaultPrintLength;
      int logLength = log.length;
      int tmpLogLength = log.length;
      while (endIndex < logLength) {
        print(log.substring(start, endIndex));
        endIndex += defaultPrintLength;
        start += defaultPrintLength;
        tmpLogLength -= defaultPrintLength;
      }
      if (tmpLogLength > 0) {
        print(log.substring(start, logLength));
      }
    }
  }

  static void shareUrl(String url) {
    Share.share(url, subject: 'SHARE');
  }

  static void changeLanguage(BuildContext context, String languageCode) {
    Locale newLocale = Locale(languageCode);
    Localizations.localeOf(context);
    Localizations.override(
      context: context,
      locale: newLocale,
    );
  }

  static String formatDateToDMY(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date).toString();
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  static Future<void> launchURL(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      try {
        await launch(url, forceSafariVC: false, forceWebView: false);
      } catch (e) {
        showSnackBar(context, '$e , Could not launch $url');
      }
    }
  }

  static Future<File> pdfFetch(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    return pdfStoreFile(url, bytes);
  }

  static Future<File> pdfStoreFile(String url, List<int> bytes) async {
    final filename = basename(url);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  static void openPDF(BuildContext context, String url) async {
    try {
      final file = await pdfFetch(url);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PDFScreen(path: file.path),
        ),
      );
    } catch (e) {
      // Handle errors
      print(e.toString());
    }
  }

  static void openPDFFromAssets(BuildContext context, String assetPath) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${basename(assetPath)}');
      final ByteData byteData = await rootBundle.load(assetPath);
      final List<int> bytes = byteData.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PDFScreen(path: file.path),
        ),
      );
    } catch (e) {
      // Handle errors
      print(e.toString());
    }
  }

  static String trimString(String? text) {
    int maxChars = 40;
    if (text != null) {
      if (text.length > maxChars) {
        return text.substring(0, maxChars) + ' ...';
      } else {
        return text;
      }
    } else {
      return 'Not Available';
    }
  }

  static String fmtToDMY(String? str) {
    if (str != null) {
      DateTime date = DateTime.parse(str);
      String formattedDate = DateFormat('dd MMM yyyy hh:mm:ss').format(date);
      return formattedDate;
    } else {
      return 'Not Available';
    }
  }
}
