import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:record/record.dart';
import 'package:waveform_flutter/waveform_flutter.dart' as waveform;

import 'platform_helper/platform_helper.dart';

/// A controller for managing audio recording and waveform generation.
class WaveformRecorderController extends ChangeNotifier {
  Stream<waveform.Amplitude>? _amplitudeStream;
  AudioRecorder? _audioRecorder;
  Uri? _url;
  var _length = Duration.zero;
  DateTime? _startTime;

  /// Indicates whether audio recording is currently in progress.
  bool get isRecording => _audioRecorder != null;

  /// Provides a stream of amplitude data for generating the waveform.
  ///
  /// Throws an exception if called when not recording.
  Stream<waveform.Amplitude> get amplitudeStream =>
      _amplitudeStream ?? (throw Exception('Not recording'));

  /// The URL of the recorded audio file, or null if no recording has been made.
  Uri? get url => _url;

  /// The duration of the recorded audio.
  Duration get length => _length;

  /// The start time of the current or last recording session.
  DateTime? get startTime => _startTime;

  @override
  void dispose() {
    _amplitudeStream = null;
    unawaited(_audioRecorder?.dispose());
    _audioRecorder = null;
    _url = null;
    _length = Duration.zero;
    _startTime = null;
    super.dispose();
  }

  /// Starts a new audio recording session.
  ///
  /// [interval] determines how often amplitude data is emitted (default is
  /// 250ms). [encoder] specifies the audio encoding format (default is
  /// platform-dependent).
  ///
  /// Throws an exception if already recording.
  Future<void> startRecording({
    Duration interval = const Duration(milliseconds: 250),
    AudioEncoder encoder = kIsWeb ? AudioEncoder.wav : AudioEncoder.aacLc,
  }) async {
    if (_audioRecorder != null) throw Exception('Already recording');
    assert(_amplitudeStream == null);
    assert(_startTime == null);
    _url = null;
    _length = Duration.zero;

    // request permissions (needed for Android)
    _audioRecorder = AudioRecorder();
    await _audioRecorder!.hasPermission();

    // start the recording into a temp file (or in memory on the web)
    _startTime = DateTime.now();
    _length = Duration.zero;
    final config = RecordConfig(encoder: encoder, numChannels: 1);
    final path = await PlatformHelper.getTempPath('m4a');
    await _audioRecorder!.start(config, path: path);

    // map the amplitude types as they stream in
    _amplitudeStream = _audioRecorder!.onAmplitudeChanged(interval).map(
          (a) => waveform.Amplitude(current: a.current, max: a.max),
        );

    notifyListeners();
  }

  /// Stops the current audio recording session.
  ///
  /// Throws an exception if not currently recording.
  Future<void> stopRecording() async {
    if (_audioRecorder == null) throw Exception('Not recording');
    assert(_url == null);
    assert(_length == Duration.zero);

    final path = await _audioRecorder!.stop() ?? '';
    if (path.isNotEmpty) {
      _url = kIsWeb ? Uri.parse(path) : Uri.file(path);
      _length = DateTime.now().difference(_startTime!);
    }

    unawaited(_audioRecorder!.dispose());
    _audioRecorder = null;
    _amplitudeStream = null;
    _startTime = null;

    notifyListeners();
  }
}
