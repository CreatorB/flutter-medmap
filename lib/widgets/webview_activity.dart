import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../const.dart';

class WebViewActivity extends StatefulWidget {
  final String title;
  final String url;
  const WebViewActivity({required this.title, required this.url});

  @override
  State<WebViewActivity> createState() => _WebViewActivityState();
}

class _WebViewActivityState extends State<WebViewActivity> {
  late final WebViewController controller;

  int loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
        onNavigationRequest: (navigation) {
          // final host = Uri.parse(navigation.url).host;
          // if (host.contains(Const.URL_WEB)) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: Text(
          //         'Blocking navigation to $host',
          //       ),
          //     ),
          //   );
          //   return NavigationDecision.prevent;
          // }
          return NavigationDecision.navigate;
        },
      ))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(widget.url),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }

  Future<void> _back() async {
    if (await controller.canGoBack()) {
      await controller.goBack();
    } else {
      // Do something
    }
  }

  Future<void> _forward() async {
    if (await controller.canGoForward()) {
      await controller.goForward();
    } else {
      // Do something
    }
  }

  Future<void> _runJs() async {
    controller.runJavaScriptReturningResult('navigator.userAgent');
  }
}
