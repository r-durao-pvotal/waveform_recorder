import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class PlatformHelper {
  static Future<String> getTempPath(String ext) async {
    final dir = await getTemporaryDirectory();
    return p.join(
      dir.path,
      'audio_${DateTime.now().millisecondsSinceEpoch}.$ext',
    );
  }
}
