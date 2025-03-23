import 'package:audioplayers/audioplayers.dart';
import 'package:cross_file/cross_file.dart';
import 'package:web/web.dart' as web;

class PlatformHelper {
  static Source audioSource(XFile file) => UrlSource(file.path);

  static Future<void> deleteFile(XFile file) async {}

  static Future<void> downloadFile(XFile file) async {
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement
      ..href = file.path
      ..style.display = 'none'
      ..download = file.name;
    web.document.body!.appendChild(anchor);
    anchor.click();
    web.document.body!.removeChild(anchor);
  }
}
