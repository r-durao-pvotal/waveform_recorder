import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:waveform_flutter/waveform_flutter.dart';

import 'waveform_recorder_controller.dart';

class WaveformRecorder extends StatefulWidget {
  const WaveformRecorder({
    required this.height,
    required this.controller,
    this.onStartRecording,
    this.onEndRecording,
    super.key,
  });

  final double height;
  final WaveformRecorderController controller;
  final Function()? onStartRecording;
  final Function({
    required String path,
    required Duration length,
  })? onEndRecording;

  @override
  State<WaveformRecorder> createState() => _WaveformRecorderState();
}

class _WaveformRecorderState extends State<WaveformRecorder> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    widget.onStartRecording?.call();
    if (widget.onEndRecording != null) {
      widget.controller.addListener(_onRecordingChange);
    }

    _timer = Timer.periodic(
      const Duration(milliseconds: 250),
      (_) => setState(() {}),
    );
  }

  void _onRecordingChange() {
    assert(widget.onEndRecording != null);
    if (!widget.controller.isRecording) {
      _timer?.cancel();
      _timer = null;
      widget.onEndRecording?.call(
        path: widget.controller.path,
        length: widget.controller.length,
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
  Widget build(BuildContext context) => SizedBox(
        height: widget.height,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(_elapsedTime),
              ),
              const Gap(8),
              Expanded(
                child: AnimatedWaveList(
                  stream: widget.controller.amplitudeStream,
                ),
              ),
            ],
          ),
        ),
      );

  String get _elapsedTime {
    final elapsed = DateTime.now().difference(widget.controller.startTime!);
    return ''
        '${elapsed.inMinutes.toString().padLeft(2, '0')}:'
        '${(elapsed.inSeconds % 60).toString().padLeft(2, '0')}';
  }
}
