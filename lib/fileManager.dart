import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:ttf_parser/ttf_parser.dart';

Directory? documentDirectory;
final parser = TtfParser();

initDocumentSystem() async {
  print('File System Loaded');
  documentDirectory = await getApplicationDocumentsDirectory();
}

void registerFile(String path) {
  if (documentDirectory == null) return;
  File(path).copy(documentDirectory!.path + "/" + path.split("/").last);
  print("Font Registered: $path");
}

String getLoadedFonts() {
  if (documentDirectory == null) return '{}';
  final fontFiles = (documentDirectory!
      .listSync(recursive: true)
      .where((element) => element.path.endsWith('.ttf'))).toList();
  Map loadableFonts = {"version": 4, "fontFiles": {}};

  fontFiles.forEach((font) {
    final parsedFont = parser.parse(File(font.path).readAsBytesSync());
    loadableFonts["fontFiles"][font.path] = [
      {
        "family": parsedFont.name.fontFamily,
        "id": parsedFont.name.fontName,
        "italic": false,
        "postscript": parsedFont.name.fontNamePostScript,
        "stretch": 5,
        "style": parsedFont.name.subFamily,
        "weight": 400
      }
    ];
  });

  return json.encode(loadableFonts);
}

String getFontBinary(String path) {
  final fontData = String.fromCharCodes(File(path).readAsBytesSync());
  return fontData;
}
