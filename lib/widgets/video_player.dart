import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class VideoPlayer extends StatefulWidget {
  final String id;
  const VideoPlayer({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            Center(
              child: CircularProgressIndicator(),
            ),
            HtmlWidget(
              '<iframe src="https://www.youtube.com/embed/${widget.id}??rel=0?version=3&autoplay=1&showinfo=0&controls=1" frameborder="0" allowfullscreen></iframe>',
              webView: true,
            ),
          ],
        ),
      ),
    );
  }
}
