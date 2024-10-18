import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:record/record.dart';
import 'package:waveform_flutter/waveform_flutter.dart' as waveform;

class WaveformRecorderController extends ChangeNotifier {
  Stream<waveform.Amplitude>? _amplitudeStream;
  AudioRecorder? _audioRecorder;
  List<int> _bytes = [];
  StreamSubscription<Uint8List>? _streamSub;

  bool get isRecording => _audioRecorder != null;
  Stream<waveform.Amplitude> get amplitudeStream =>
      _amplitudeStream ?? (throw Exception('Not recording'));
  Uint8List get bytes => Uint8List.fromList(_bytes);

  @override
  void dispose() {
    _bytes = [];
    _amplitudeStream = null;
    unawaited(_audioRecorder?.dispose());
    _audioRecorder = null;
    unawaited(_streamSub?.cancel());
    _streamSub = null;
    super.dispose();
  }

  Future<void> startRecording({
    Duration interval = const Duration(milliseconds: 250),
    AudioEncoder encoder = AudioEncoder.pcm16bits,
  }) async {
    if (_audioRecorder != null) throw Exception('Already recording');
    assert(_amplitudeStream == null);
    assert(_streamSub == null);

    // cache the bytes as they stream in
    _audioRecorder = AudioRecorder();
    final config = RecordConfig(encoder: encoder, numChannels: 1);
    final byteStream = await _audioRecorder!.startStream(config);
    _bytes = [];
    _streamSub = byteStream.listen((bytes) => _bytes.addAll(bytes));

    // map the amplitude types as they stream in
    _amplitudeStream = _audioRecorder!.onAmplitudeChanged(interval).map(
          (a) => waveform.Amplitude(current: a.current, max: a.max),
        );

    notifyListeners();
  }

  Future<void> stopRecording() async {
    if (_audioRecorder == null) throw Exception('Not recording');

    await _audioRecorder!.stop();
    unawaited(_audioRecorder!.dispose());
    _audioRecorder = null;
    unawaited(_streamSub?.cancel());
    _streamSub = null;
    _amplitudeStream = null;

    notifyListeners();
  }
}
