import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:waveform_flutter/waveform_flutter.dart';

import 'waveform_recorder_controller.dart';

class WaveformRecorder extends StatefulWidget {
  const WaveformRecorder({
    required this.height,
    required this.controller,
    this.onRecordingDone,
    super.key,
  });

  final double height;
  final WaveformRecorderController controller;
  final Function({
    required Uint8List bytes,
    required Duration duration,
  })? onRecordingDone;

  @override
  State<WaveformRecorder> createState() => _WaveformRecorderState();
}

class _WaveformRecorderState extends State<WaveformRecorder> {
  final DateTime _startTime = DateTime.now();
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    if (widget.onRecordingDone != null) {
      widget.controller.addListener(_onRecordingChange);
    }

    _timer = Timer.periodic(
      const Duration(milliseconds: 250),
      (_) => setState(() {}),
    );
  }

  void _onRecordingChange() {
    assert(widget.onRecordingDone != null);
    if (!widget.controller.isRecording) {
      final duration = DateTime.now().difference(_startTime);
      widget.onRecordingDone?.call(
        bytes: widget.controller.bytes,
        duration: duration,
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.controller.removeListener(_onRecordingChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          const Gap(8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(_elapsedTime),
          ),
          const Gap(8),
          Expanded(
            child: SizedBox(
              height: widget.height,
              child: AnimatedWaveList(
                stream: widget.controller.amplitudeStream,
              ),
            ),
          ),
          const Gap(8),
        ],
      );

  String get _elapsedTime {
    final elapsed = DateTime.now().difference(_startTime);
    return ''
        '${elapsed.inMinutes.toString().padLeft(2, '0')}:'
        '${(elapsed.inSeconds % 60).toString().padLeft(2, '0')}';
  }
}
