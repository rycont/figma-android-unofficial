import 'dart:io';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ttf_parser/ttf_parser.dart';

Directory? documentDirectory;
final parser = TtfParser();

@JsonSerializable()
class ServerableFont {
  final String family;
  final String id;
  final bool italic;
  final String postscript;
  final String style;
  final int stretch;
  final int weight;
  final String path;

  ServerableFont(
      {required this.family,
      required this.id,
      required this.italic,
      required this.postscript,
      required this.style,
      required this.stretch,
      required this.weight,
      required this.path});

  toMap() => {family, id, italic, postscript, style, stretch, weight, path};
}

initDocumentSystem() async {
  print('File System Loaded');
  documentDirectory = await getApplicationDocumentsDirectory();
}

void registerFile(String path) {
  if (documentDirectory == null) return;
  File(path).copy(documentDirectory!.path + "/" + path.split("/").last);
  print("Font Registered: $path");
}

void skiaLoad(List<ServerableFont> serverableList) {
  serverableList.forEach((serverable) {
    FontLoader(serverable.family)
      ..addFont(File(serverable.path)
          .readAsBytes()
          .then((value) => value.buffer.asByteData()))
      ..load();
  });
}

List<ServerableFont> getLoadedFonts() {
  if (documentDirectory == null) return [];
  final fontFiles = (documentDirectory!
      .listSync(recursive: true)
      .where((element) => element.path.endsWith('.ttf'))).toList();
  List<ServerableFont> loadableFonts = [];

  fontFiles.forEach((font) {
    final parsedFont = parser.parse(File(font.path).readAsBytesSync());

    if (parsedFont.name.fontFamily == null ||
        parsedFont.name.fontName == null ||
        parsedFont.name.fontNamePostScript == null ||
        parsedFont.name.subFamily == null) throw "Not enough font info";

    loadableFonts.add(ServerableFont(
        family: parsedFont.name.fontFamily!,
        id: parsedFont.name.fontName!,
        italic: false,
        postscript: parsedFont.name.fontNamePostScript!,
        stretch: 5,
        style: parsedFont.name.subFamily!,
        weight: 400,
        path: font.path));
  });

  return loadableFonts;
}

String getFontBinary(String path) {
  final fontData = String.fromCharCodes(File(path).readAsBytesSync());
  return fontData;
}
