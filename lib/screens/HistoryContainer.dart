import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tedx_niit/screens/video_list.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


/// Homepage

final List<String> _urls19 = [
  'https://youtu.be/ZljJEjJ7n_g?list=PLsRNoUx8w3rO01rum8RfjQn5LVl5Vq7Ka',
  'https://youtu.be/PjrM3G8PCb8?list=PLsRNoUx8w3rO01rum8RfjQn5LVl5Vq7Ka',
  'https://youtu.be/ysYik6Ptfy4?list=PLsRNoUx8w3rO01rum8RfjQn5LVl5Vq7Ka',
  'https://youtu.be/taQbsxI-IfU?list=PLsRNoUx8w3rO01rum8RfjQn5LVl5Vq7Ka',
  'https://youtu.be/umH9yka1siY?list=PLsRNoUx8w3rO01rum8RfjQn5LVl5Vq7Ka',
  'https://youtu.be/0qsQpUJv-Ck?list=PLsRNoUx8w3rO01rum8RfjQn5LVl5Vq7Ka',
  'https://youtu.be/4wa3XDh72lE?list=PLsRNoUx8w3rO01rum8RfjQn5LVl5Vq7Ka',
  'https://youtu.be/VaegXWjUhN0?list=PLsRNoUx8w3rO01rum8RfjQn5LVl5Vq7Ka',
];

final List<String> _url_ids = _urls19.map((url) {
  return YoutubePlayer.convertUrlToId(url);
}).toList();

class HistoryContainer extends StatefulWidget {
  var videoId;
  HistoryContainer({this.videoId});
  @override
  _HistoryContainerState createState() => _HistoryContainerState();
}

class _HistoryContainerState extends State<HistoryContainer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;

  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  int count = 0;




  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHideAnnotation: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Container(
            height: 50,
            width: MediaQuery.of(context).size.width/2,
            child: Image(
              image: AssetImage('images/TEDxNIITUniversity3.png'),
              fit: BoxFit.scaleDown,
            )),
        actions: [
          IconButton(
            icon: Icon(Icons.video_library,color: Colors.black,),
            onPressed: () => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => VideoList(),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.red,
            topActions: <Widget>[
              SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  _controller.metadata.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 25.0,
                ),
                onPressed: () {
                  _showSnackBar('Settings Tapped!');
                },
              ),
            ],
            onReady: () {
              _isPlayerReady = true;
            },
            onEnded: (id) {
              _controller.load(_url_ids[count++]);
              _showSnackBar('Next Video Started!');
            },
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _space,
                _text(
                  'Title',
                  _videoMetaData.title,
                ),
                _space,
                _text('Channel', _videoMetaData.author),
                _space,
                _text('Video Id', _videoMetaData.videoId),
                _space,
                Row(
                  children: [
                    _text(
                      'Playback Quality',
                      _controller.value.playbackQuality,
                    ),
                    Spacer(),
                    _text(
                      'Playback Rate',
                      '${_controller.value.playbackRate}x  ',
                    ),
                  ],
                ),
                _space,
                /*TextField(
                  enabled: _isPlayerReady,
                  controller: _idController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter youtube \<video id\> or \<link\>',
                    fillColor: Colors.blueAccent.withAlpha(20),
                    filled: true,
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.blueAccent,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () => _idController.clear(),
                    ),
                  ),
                ),*/
                _space,
               /* Row(
                  children: [
                    _loadCueButton('LOAD'),
                    SizedBox(width: 10.0),
                    _loadCueButton('CUE'),
                  ],
                ),*/
                _space,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                      onPressed: _isPlayerReady
                          ? () {
                              _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play();
                              setState(() {});
                            }
                          : null,
                    ),
                    IconButton(
                      icon: Icon(_muted ? Icons.volume_off : Icons.volume_up),
                      onPressed: _isPlayerReady
                          ? () {
                              _muted
                                  ? _controller.unMute()
                                  : _controller.mute();
                              setState(() {
                                _muted = !_muted;
                              });
                            }
                          : null,
                    ),
                    FullScreenButton(
                      controller: _controller,
                      color: Colors.black,
                    ),
                  ],
                ),
                _space,
                Row(
                  children: <Widget>[
                    Text(
                      "Volume",
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    Expanded(
                      child: Slider(
                        inactiveColor: Colors.transparent,
                        activeColor: Colors.red,
                        value: _volume,
                        min: 0.0,
                        max: 100.0,
                        divisions: 20,
                        label: '${(_volume).round()}',
                        onChanged: _isPlayerReady
                            ? (value) {
                                setState(() {
                                  _volume = value;
                                });
                                _controller.setVolume(_volume.round());
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
                _space,
                /*AnimatedContainer(
                  duration: Duration(milliseconds: 800),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: _getStateColor(_playerState),
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    _playerState.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value ?? '',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStateColor(PlayerState state) {
    switch (state) {
      case PlayerState.unknown:
        return Colors.grey[700];
      case PlayerState.unStarted:
        return Colors.pink;
      case PlayerState.ended:
        return Colors.red;
      case PlayerState.playing:
        return Colors.blueAccent;
      case PlayerState.paused:
        return Colors.orange;
      case PlayerState.buffering:
        return Colors.yellow;
      case PlayerState.cued:
        return Colors.blue[900];
      default:
        return Colors.blue;
    }
  }

  Widget get _space => SizedBox(height: 10);

  Widget _loadCueButton(String action) {
    return Expanded(
      child: MaterialButton(
        color: Colors.red,
        onPressed: _isPlayerReady
            ? () {
                if (_idController.text.isNotEmpty) {
                  var id = YoutubePlayer.convertUrlToId(
                    _idController.text,
                  );
                  if (action == 'LOAD') _controller.load(id);
                  if (action == 'CUE') _controller.cue(id);
                  FocusScope.of(context).requestFocus(FocusNode());
                } else {
                  _showSnackBar('Source can\'t be empty!');
                }
              }
            : null,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(
            action,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}
