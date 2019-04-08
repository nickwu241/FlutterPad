import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:webview_flutter/webview_flutter.dart';

final kSoundFiles = [
  'Clap.wav',
  'Crash.wav',
  'High Tom.wav',
  'Hihat C.wav',
  'Hihat O.wav',
  'Kick.wav',
  'Low Tom.wav',
  'Mid Tom.wav',
  'Rimshot.wav',
  'Snare.wav',
];
final kYoutubePlaylistUrl =
    'https://www.youtube.com/watch?v=YIqGve9SlSk&list=PLmGpMN55CphlhZqsFHvR3y8Kyze1ZMqLq';

void main() {
  // Force App to always be Portrait mode.
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AudioCache _audio = AudioCache(prefix: 'audio/');
  WebViewController _webViewController;
  bool _isShowingYoutubePage;

  @override
  void initState() {
    super.initState();
    _audio.loadAll(kSoundFiles);
    _isShowingYoutubePage = false;
  }

  /// Builds a drum pad widget with a specific color and sound effect.
  Widget _buildDrumPad(Color color, String sound) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: MaterialButton(
        child: Text(sound),
        minWidth: 110,
        height: 110,
        color: color,
        onPressed: () => _audio.play('$sound.wav'),
      ),
    );
  }

  /// Builds the action widgets for an AppBar.
  List<Widget> _buildAppBarActions() {
    final actions = <Widget>[
      FlatButton(
        child: Text(
          _isShowingYoutubePage ? 'Close YouTube' : 'Play along to songs',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: _toggleYoutubePage,
      ),
    ];

    // Only show navigation buttons if the WebView is opened.
    if (_isShowingYoutubePage) {
      actions.insertAll(0, [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _webViewGoBack,
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: _webViewGoForward,
        ),
      ]);
    }

    return actions;
  }

  void _toggleYoutubePage() {
    setState(() => _isShowingYoutubePage = !_isShowingYoutubePage);
  }

  void _webViewGoForward() async {
    if (await _webViewController.canGoForward()) {
      _webViewController.goForward();
    }
  }

  void _webViewGoBack() async {
    if (await _webViewController.canGoBack()) {
      _webViewController.goBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterPad',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: Scaffold(
        appBar: AppBar(actions: _buildAppBarActions()),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isShowingYoutubePage
                ? Flexible(
                    child: WebView(
                      initialUrl: kYoutubePlaylistUrl,
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController webViewController) {
                        _webViewController = webViewController;
                      },
                    ),
                  )
                : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDrumPad(Colors.purple[200], 'Low Tom'),
                _buildDrumPad(Colors.blue[200], 'Mid Tom'),
                _buildDrumPad(Colors.green[200], 'High Tom'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDrumPad(Colors.teal[200], 'Hihat C'),
                _buildDrumPad(Colors.teal[200], 'Hihat O'),
                _buildDrumPad(Colors.red[200], 'Crash'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDrumPad(Colors.orange[300], 'Clap'),
                _buildDrumPad(Colors.orange[300], 'Snare'),
                _buildDrumPad(Colors.yellow[400], 'Kick'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
