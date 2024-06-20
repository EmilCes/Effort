import 'dart:async';
import 'dart:io';

import 'package:effort/utils/constants/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';

class VideoPlayerWidget extends StatefulWidget {
  final ValueNotifier<XFile?>? videoNotifier;
  final XFile? video;
  final bool isEditing;

  const VideoPlayerWidget({Key? key, this.videoNotifier, this.video, this.isEditing = false})
      : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  Timer? _hideControlsTimer;
  bool _showControls = true;
  bool _videoLoaded = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.asset('');
    _videoPlayerController.addListener(_onVideoPlayerChanged);

    if (widget.video != null) {
      _initializeVideoPlayer(File(widget.video!.path));
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  void _initializeVideoPlayer(File videoFile) async {
    _videoPlayerController = VideoPlayerController.file(videoFile);
    await _videoPlayerController.initialize();
    setState(() {
      _videoLoaded = true;
    });
    _videoPlayerController.play();
    _startHideControlsTimer();
  }

  void _onVideoPlayerChanged() {
    if (_videoPlayerController.value.isPlaying) {
      _startHideControlsTimer();
    }
    setState(() {});
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 1), () {
      if (_showControls) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _toggleControlsVisibility() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _startHideControlsTimer();
    } else {
      _hideControlsTimer?.cancel();
    }
  }

  /*void _uploadVideo() async {
    final XFile? file = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (file != null) {
      File videoFile = File(file.path);
      widget.videoNotifier?.value = file;
      _initializeVideoPlayer(videoFile);
    }
  }*/

  void _uploadVideo() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      final result = await FilePicker.platform.pickFiles(type: FileType.video);
      if (result != null && result.files.single.path != null) {
        File videoFile = File(result.files.single.path!);
        widget.videoNotifier?.value = XFile(result.files.single.path!);
        _initializeVideoPlayer(videoFile);
      }
    } else {
      final XFile? file = await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (file != null) {
        File videoFile = File(file.path);
        widget.videoNotifier?.value = file;
        _initializeVideoPlayer(videoFile);
      }
    }
  }

  void _removeVideo() {
    setState(() {
      _videoPlayerController.pause();
      _videoPlayerController = VideoPlayerController.asset('');
      _videoLoaded = false;
      widget.videoNotifier?.value = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleControlsVisibility,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(20)
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: VideoPlayer(_videoPlayerController),
              ),
            ),
          ),
          if (widget.isEditing && _videoLoaded)
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: EffortColors.white),
                onPressed: _removeVideo,
              ),
            ),
          AnimatedOpacity(
            opacity: _showControls ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_videoLoaded && _videoPlayerController.value.isPlaying)
                  IconButton(
                    icon: const Icon(Icons.pause, size: 50, color: EffortColors.white),
                    onPressed: () {
                      _videoPlayerController.pause();
                    },
                  ),
                if (_videoLoaded && !_videoPlayerController.value.isPlaying)
                  IconButton(
                    icon: const Icon(Icons.play_arrow, size: 50, color: EffortColors.white),
                    onPressed: () {
                      _videoPlayerController.play();
                    },
                  ),
              ],
            ),
          ),
          if (!_videoLoaded)
            ElevatedButton(
              onPressed: _uploadVideo,
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
              ),
              child: const Text('Subir Video'),
            ),
        ],
      ),
    );
  }
}
