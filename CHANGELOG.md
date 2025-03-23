## 1.6.2

* README screenshot tweak

## 1.6.1

* fix [#8](https://github.com/csells/waveform_recorder/issues/8): Display
  waveform if not recording; exposed `amplitudeStream` from the
  `WaveformRecorderController` as a broadcast stream to enable listeners to
  gather the amplitudes for their own purpose, e.g. to show their own waveform

* added a `WaveformController.clear()` method to reset the controller back to
  the original state

* updated the example app to show the waveform after it's been recorded
  (although it's pretty ugly as it is; PRs appreciated!)

* updated the example app to allow for deleted the recorded file

* updated the example app to allow for downloading the recorded file

## 1.6.0

* fix [#5](https://github.com/csells/waveform_recorder/issues/5): Add ability to
  pause recording. Thanks to @Shashwat-111 for [the
  PR](https://github.com/csells/waveform_recorder/pull/6)!

## 1.5.0

* fix [#3](https://github.com/csells/waveform_recorder/issues/3): Add a cancel
option. Thanks to @YajatKaul for [the PR](https://github.com/csells/waveform_recorder/pull/4)!

## 1.4.0

* fix [#2](https://github.com/csells/waveform_recorder/issues/2): Add a
customization option for colors for wave bar and duration text

## 1.3.1

* Add an on waveController.cancel option to it #3

* README tweak

## 1.3.0

* downgraded the SDK requiredment to allow for more users

## 1.2.2

* setting file name extension and mimetype based on audio encoder
* moved `Uri url` => `XFile file` for split of path and name (necessary on the web)
* downgraded the SDK requiredment to allow for more users

## 1.2.1

* improved audio playback in the sample

## 1.2

* change onStartRecording => onRecordingStarted
* change onEndRecording => onRecordingStopped
* fixed issue on second recording -- yay asserts!

## 1.0.1

* fix missing file.

## 1.0.0

* initial release.
