import 'package:figma_unofficial/fileManager.dart';
import 'package:figma_unofficial/server.dart';
import 'package:figma_unofficial/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
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
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    ReceiveSharingIntent.getInitialMedia().then((value) {
      print('Shared file received');
      value.forEach((file) {
        registerFile(file.path);
      });

      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
        home: CupertinoPageScaffold(
            child: SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: 48, right: 48, bottom: 12, top: 36),
        child: Row(
          children: [
            Expanded(child: Row(
              children: [
                SvgPicture.asset('lib/assets/figma.svg'),
                Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    'Figma FontLoader',
                    style: brandTextStyle,
                  ),
                )
              ],
            )),
            Row(
              children: [Container(
              decoration: addButtonStyle(Color(0xFF0ACF83).withOpacity(0.08)),
              padding: EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: SvgPicture.asset(
                      'lib/assets/server.svg',
                      color: Color(0xFF0ACF83),
                      height: 14,
                    ),
                  ),
                  Text(
                    'Loader Status Good',
                    style: addButtonLabelStyle.merge(TextStyle(
                      color: Color(0xFF0ACF83)
                    )),
                  ),
                ],
              ),
            ),Padding(padding: EdgeInsets.only(left: 12), child: Container(
              decoration: addButtonStyle(),
              padding: EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: SvgPicture.asset(
                      'lib/assets/addFile.svg',
                      color: Color(0xFFFFFFFF),
                      height: 14,
                    ),
                  ),
                  Text(
                    'Load File',
                    style: addButtonLabelStyle,
                  ),
                ],
              ),
            ),),],
            )
          ],
        ),
      ),
    )));
  }
}
