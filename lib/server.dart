import 'dart:convert';
import 'dart:io';

import 'package:figma_unofficial/fileManager.dart';

startServer() async {
  print("파일 서버시스템 준비 완료");
  var server = await HttpServer.bind('127.0.0.1', 18412);
  print('Listening on localhost:${server.port}');

  await for (HttpRequest request in server) {
    // print();
    request.response.headers
        .add("Access-Control-Allow-Origin", "https://www.figma.com");
    if (request.requestedUri.path == '/figma/font-files') {
      request.response.headers.add("Content-Type", "application/json");
      request.response.write(getLoadedFonts());
    } else if (request.requestedUri.path == '/figma/font-file') {
      request.response.headers.add("Content-Type", "application/octet-stream");
      final requestedPath = request.requestedUri.queryParameters['file'];
      if (requestedPath != null)
        request.response.write(getFontBinary(requestedPath));
    } else
      request.response.write(json.encode({"asdf": "sdfg"}));
    await request.response.close();
  }
}
