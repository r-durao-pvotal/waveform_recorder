/// A helper class for platform-specific operations: web version
class PlatformHelper {
  /// Generates a temporary path for audio recording on web platforms.
  ///
  /// This method returns an empty string for web platforms as temporary file
  /// paths are not applicable in the web context. Audio data is handled via
  /// blob URLs on the web.
  ///
  /// [ext] is the file extension for the audio file (e.g., 'm4a', 'wav'). This
  /// parameter is ignored in the web implementation.
  static Future<String> getTempPath(String ext) async => '';

  /// Deletes a temporary audio file at the specified path.
  ///
  /// This method is a no-op on web platforms since temporary files are handled
  /// via blob URLs which are automatically cleaned up by the browser.
  ///
  /// [path] is ignored in the web implementation since file paths are not
  /// applicable in the web context.
  static Future<void> deleteTempAudioFile(String path) async {}
}
