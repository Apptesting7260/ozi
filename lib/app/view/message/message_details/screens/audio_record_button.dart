// import 'package:flutter/material.dart';
// import 'package:record/record.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
//
// import '../../../../../../Custom/widgets/custom_image.dart';
// import '../../../../../../core/constants/image_constant.dart';
//
// class AudioRecorderButton extends StatefulWidget {
//   final Function(File audioFile) onAudioSend;
//
//   const AudioRecorderButton({super.key, required this.onAudioSend});
//
//   @override
//   _AudioRecorderButtonState createState() => _AudioRecorderButtonState();
// }
//
// class _AudioRecorderButtonState extends State<AudioRecorderButton> {
//   final _record = AudioRecorder();
//   bool _isRecording = false;
//   String? _filePath;
//
//   Future<String> _getFilePath() async {
//     final dir = await getTemporaryDirectory();
//     return '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.wav';
//   }
//
//   Future<void> _handleTap() async {
//     if (!_isRecording) {
//       // Start recording
//       if (await _record.hasPermission()) {
//         _filePath = await _getFilePath();
//         await _record.start(
//           const RecordConfig(encoder: AudioEncoder.wav), path: _filePath!,
//         );
//         setState(() => _isRecording = true);
//       }
//     } else {
//       // Stop recording and send file
//       final path = await _record.stop();
//       setState(() => _isRecording = false);
//
//       if (_filePath != null) {
//         widget.onAudioSend(File(path!));
//       }
//       _record.dispose();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _handleTap,
//       child: _isRecording?CustomImage(path: ImageConstants.micIcon,color: Colors.green,):CustomImage(path: ImageConstants.micIcon)
//
//       // Icon(
//       //   _isRecording ? Icons.stop_circle : Icons.mic,
//       //   color: _isRecording ? Colors.red : Colors.black,
//       //   size: 32,
//       // ),
//     );
//   }
// }
