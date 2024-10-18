import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:waveform_recorder/waveform_recorder.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _textController = TextEditingController();
  final _waveController = WaveformRecorderController();

  @override
  void dispose() {
    _textController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('WaveForm Example')),
          body: ListenableBuilder(
            listenable: _waveController,
            builder: (context, _) => Column(
              children: [
                Expanded(
                  child: Center(
                    child: OutlinedButton(
                      onPressed: !_waveController.isRecording &&
                              _waveController.path.isNotEmpty
                          ? _playRecording
                          : null,
                      child: const Text('Play'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _waveController.isRecording
                              ? WaveformRecorder(
                                  height: 48,
                                  controller: _waveController,
                                  onEndRecording: _onEndRecording,
                                )
                              : TextField(
                                  controller: _textController,
                                  maxLines: 1,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const Gap(8),
                      IconButton(
                        icon: Icon(
                          _waveController.isRecording ? Icons.stop : Icons.mic,
                        ),
                        onPressed: _toggleRecording,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Future<void> _toggleRecording() => switch (_waveController.isRecording) {
        true => _waveController.stopRecording(),
        false => _waveController.startRecording(),
      };

  void _onEndRecording({
    required String path,
    required Duration length,
  }) =>
      _textController.text = '$path: ${length.inMilliseconds / 1000} seconds';

  // TODO: cross_file
  void _playRecording() => unawaited(
        AudioPlayer().play(kIsWeb
            ? UrlSource(_waveController.path)
            : DeviceFileSource(_waveController.path)),
      );
}
