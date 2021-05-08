import 'dart:io';

import 'package:figma_unofficial/fileManager.dart';
import 'package:figma_unofficial/server.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';

const SERVICE_ORIGIN = 'https://www.figma.com';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDocumentSystem();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  runApp(MyApp());
  startServer();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  MyApp() {
    print("아니 미안한데");
  }
}

class _MyAppState extends State<MyApp> {
  InAppWebViewController? webView;
  String? initString;
  CookieManager cookieManager = CookieManager.instance();

  void listenURLIntent() async {
    uriLinkStream.listen((Uri? uri) {
      if (webView != null) {
        webView!.loadUrl(
            urlRequest: URLRequest(
                url: Uri.parse(uri
                    .toString()
                    .replaceFirst('figma://', 'https://figma.com/'))));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    listenURLIntent();
    print("파일 받을 준비 됨!");
    ReceiveSharingIntent.getInitialMedia().then((value) {
      print('파일 진짜받음 ㄷㄷ');
      // webView
      value.forEach((file) {
        registerFile(file.path);
      });

      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Text('예에')
      )
    );
  }
}
