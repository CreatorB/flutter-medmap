import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'views/pdf_screen.dart';

class Utils {
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
      showSnackBar(context, 'Could not launch $url');
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
}
