import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// A helper class for platform-specific operations: non-web
class PlatformHelper {
  /// Generates a temporary file path for audio recording.
  ///
  /// This method creates a unique file path in the temporary directory for
  /// storing audio recordings.
  ///
  /// [ext] is the file extension for the audio file (e.g., 'm4a', 'wav').
  ///
  /// Returns a [Future] that completes with the generated file path as a
  /// [String].
  static Future<String> getTempPath(String ext) async {
    final dir = await getTemporaryDirectory();
    return p.join(
      dir.path,
      'audio-${DateTime.now().millisecondsSinceEpoch}.$ext',
    );
  }

  /// Deletes a temporary audio file at the specified path.
  ///
  /// This method attempts to delete the file at [path] if it exists. If the
  /// path is empty or if there are any errors during deletion, they are handled
  /// gracefully.
  ///
  /// [path] is the file system path to the temporary audio file to be deleted.
  static Future<void> deleteTempAudioFile(String path) async {
    if (path.isNotEmpty) {
      // delete the temporary file (if there is one)
      try {
        final tempFile = File(path);
        if (tempFile.existsSync()) await tempFile.delete();
      } on Exception catch (e) {
        debugPrint('Error deleting temp recording file: $e');
      }
    }
  }
}
