import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatefulWidget {
  final initialVideoId;

  const VideoPlayer(this.initialVideoId, {Key? key}) : super(key: key);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late YoutubePlayerController _controller;
  var _isFullScreenActive = false;

  // late PlayerState _playerState;
  // late YoutubeMetaData _videoMetaData;
  // final double _volume = 100;
  // final bool _muted = false;
  // final bool _isPlayerReady = false;

  // void listener() {
  //   if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
  //     setState(() {
  //       _playerState = _controller.value.playerState;
  //       _videoMetaData = _controller.metadata;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.initialVideoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
      ),
    );
    //   ..addListener(listener);
    // _videoMetaData = const YoutubeMetaData();
    // print(_videoMetaData);
    // print(_volume);
    // print(_muted);
    // print(_isPlayerReady);
    // print(_playerState);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: () async {
            if (_isFullScreenActive == false) {
              SystemChrome.setPreferredOrientations(DeviceOrientation.values);
              Navigator.pop(context);
            } else {
              SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp]);
            }
            return false;
          },
          child: Center(
            child: YoutubePlayerBuilder(
              onExitFullScreen: () {
                setState(() {
                  _isFullScreenActive = false;
                });
              },
              onEnterFullScreen: () {
                setState(() {
                  _isFullScreenActive = true;
                });
              },
              player: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.amber,
                progressColors: ProgressBarColors(
                  playedColor: Colors.amber,
                  handleColor: Colors.amberAccent,
                ),
                bottomActions: [
                  CurrentPosition(),
                  SizedBox(width: 10),
                  ProgressBar(isExpanded: true),
                  IconButton(
                    icon: Icon(
                      _isFullScreenActive
                          ? Icons.fullscreen_exit_rounded
                          : Icons.fullscreen_rounded,
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    onPressed: () {
                      if (_isFullScreenActive) {
                        SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.portraitUp],
                        );
                      } else {
                        SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.landscapeRight],
                        );
                      }
                    },
                  ),
                ],
                onReady: () {
                  _controller.addListener(() {});
                },
              ),
              builder: (context, player) {
                return Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: player,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
