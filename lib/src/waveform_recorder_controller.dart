import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:record/record.dart';
import 'package:waveform_flutter/waveform_flutter.dart' as waveform;

import 'platform_helper/platform_helper.dart';

class WaveformRecorderController extends ChangeNotifier {
  Stream<waveform.Amplitude>? _amplitudeStream;
  AudioRecorder? _audioRecorder;
  var _path = '';
  var _length = Duration.zero;
  DateTime? _startTime;

  bool get isRecording => _audioRecorder != null;
  Stream<waveform.Amplitude> get amplitudeStream =>
      _amplitudeStream ?? (throw Exception('Not recording'));
  String get path => _path;
  Duration get length => _length;
  DateTime? get startTime => _startTime;

  @override
  void dispose() {
    _amplitudeStream = null;
    unawaited(_audioRecorder?.dispose());
    _audioRecorder = null;
    _path = '';
    _length = Duration.zero;
    _startTime = null;
    super.dispose();
  }

  Future<void> startRecording({
    Duration interval = const Duration(milliseconds: 250),
    AudioEncoder encoder = kIsWeb ? AudioEncoder.wav : AudioEncoder.aacLc,
  }) async {
    if (_audioRecorder != null) throw Exception('Already recording');
    assert(_amplitudeStream == null);
    assert(_startTime == null);

    // start the recording into a temp file (or in memory on the web)
    _startTime = DateTime.now();
    _length = Duration.zero;
    _audioRecorder = AudioRecorder();
    final config = RecordConfig(encoder: encoder, numChannels: 1);
    final path = await PlatformHelper.getTempPath('m4a');
    await _audioRecorder!.start(config, path: path);

    // map the amplitude types as they stream in
    _amplitudeStream = _audioRecorder!.onAmplitudeChanged(interval).map(
          (a) => waveform.Amplitude(current: a.current, max: a.max),
        );

    notifyListeners();
  }

  Future<void> stopRecording() async {
    if (_audioRecorder == null) throw Exception('Not recording');

    _path = await _audioRecorder!.stop() ?? '';
    if (_path.isNotEmpty) {
      _length = DateTime.now().difference(_startTime!);
    }

    unawaited(_audioRecorder!.dispose());
    _audioRecorder = null;
    _amplitudeStream = null;
    _startTime = null;

    notifyListeners();
  }
}
