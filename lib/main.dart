import 'dart:io';

import 'package:figma_unofficial/fileManager.dart';
import 'package:figma_unofficial/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:url_launcher/url_launcher.dart';

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
  @override
  void initState() {
    super.initState();
    print("파일 받을 준비 됨!");
    ReceiveSharingIntent.getInitialMedia().then((value) {
      print('파일 진짜받음 ㄷㄷ');
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
          body: InAppWebView(
        initialUrlRequest:
            URLRequest(url: Uri.parse('https://figma.com/login')),
        onWebViewCreated: (controller) {
          controller.addJavaScriptHandler(
              handlerName: 'MESSAGE_HANDELR',
              callback: (e) {
                // print('뭔가됨');
                final String action = e[0][0][0];
                final data = e[0][0][1];
                print("뭔가됨 $action $data");
                if (action == 'startAppAuth') {
                  launch("$SERVICE_ORIGIN${data["grantPath"]}");
                  print("열기주소! $SERVICE_ORIGIN${data["grantPath"]}");
                }
              });
        },
        onLoadStart: (controller, url) {
          controller.evaluateJavascript(source: """
            function sendPost(...arg) {
              window.flutter_inappwebview.callHandler('MESSAGE_HANDELR', arg)
            }
            window.__figmaDesktop = {
              version: 36,
              fileBrowser: true,
              postMessage(...e) {
                console.log('포스트포스트')
                sendPost(e)
              },
              registerCallback(...e) {
                console.log('registerCallback', e);
              },
              promiseMessage(...e) {
                console.log('promiseMessage', e);
              },
              registerCallback(...e) {
                console.log('registerCallback', e);
              },
              setMessageHandler(...e) {
                console.log('setMessageHandler', e);
              },
            };
          """);
          print("로드시작! $url");
        },
        onConsoleMessage: (controller, message) => {print("웹뷰로그 $message")},
        onLoadStop: (controller, title) {
          controller.evaluateJavascript(source: """
            const newMeta = document.createElement('meta');
            newMeta.name = "viewport"
            newMeta.content = "width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"
            document.head.appendChild(newMeta)
            console.log(newMeta)
          """);
          print("주입함");
        },
      )),
    );
  }
}
