import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:ttf_parser/ttf_parser.dart';

Directory? documentDirectory;
final parser = TtfParser();

initDocumentSystem() async {
  print('File System Loaded');
  documentDirectory = await getApplicationDocumentsDirectory();
}

class LoadedFont {
  final String path;
  final String name;
  LoadedFont({required this.path, required this.name});
}

void registerFile(String path) {
  if (documentDirectory == null) return;
  File(path).copy(documentDirectory!.path + "/" + path.split("/").last);
  print("Font Registered: $path");
}

String getLoadedFonts() {
  if (documentDirectory == null) '{}';
  final fontFiles = (documentDirectory!
      .listSync(recursive: true)
      .where((element) => element.path.endsWith('.ttf'))).toList();
  Map loadableFonts = {"version": 4, "fontFiles": {}};

  fontFiles.forEach((font) {
    // final fontName = font.path.split('/').last;
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
