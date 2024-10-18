The waveform_recorder package provides a widget to show a waveform as an audio stream is being recorded in the style of recent AI chat packages.

![Screenshot of waveform_recorder in action](https://raw.githubusercontent.com/csells/waveform_recorder/refs/heads/main/readme/screenshot3.png)

## Setup

For this package to work, you'll need to set up the underlying `record` package according to the instructions here: https://pub.dev/packages/record#setup-permissions-and-others

## Usage

The main entry point for this package is the `WaveformRecorder` widget, which requires an instance of the `WaveformRecorderController` to start/stop recording. Here's an example of using the recorder to record and then playing back the recorded audio:

```dart
TODO: update
```

### Usage Considerations

For all platforms except the web, the output of a record operation is a file on your hard drive; it's your app's responsibility to remove this temp file when it's done with it. When executing on the web, the URL of the recorded audio will be a blob URL but otherwise, it will be a URL with a `file` scheme. You can get the path to that file from the `WaveformRecorderController.url` property, e.g.

```dart
Future<void> _deleteRecording() async {
  if (_waveController.url?.isScheme('file') ?? false) {
    await File(_waveController.url!.path).delete();
  }
}
```

## Feedback

Your feedback via [issues](https://github.com/csells/waveform_recorder/issues) or [PRs](https://github.com/csells/waveform_recorder/pulls) is welcome!