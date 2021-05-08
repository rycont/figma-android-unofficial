import 'package:figma_unofficial/fileManager.dart';
import 'package:figma_unofficial/server.dart';
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDocumentSystem();
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
        appBar: AppBar(
          title: Text("아진짜요"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
