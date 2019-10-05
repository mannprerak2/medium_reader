import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:clipboard_manager/clipboard_manager.dart';

class ReaderScreen extends StatefulWidget {
  final String url;

  const ReaderScreen({Key key, this.url}) : super(key: key);
  @override
  _ReaderScreenState createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  bool showLoader = true;
  WebViewController _controller;
  final _sk = GlobalKey<ScaffoldState>();
  final _lk = GlobalKey<ProgressIndicatorCustomState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_controller == null) {
          return true;
        } else if (await _controller.canGoBack()) {
          _lk.currentState.setLoading(true);
          await _controller.goBack();
          await Future.delayed(Duration(seconds: 1));
          _lk.currentState.setLoading(false);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        key: _sk,
        appBar: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  iconSize: 20,
                  onPressed: () async {
                    if (await _controller.canGoBack()) {
                      _lk.currentState.setLoading(true);
                      await _controller.goBack();
                      await Future.delayed(Duration(seconds: 1));
                      _lk.currentState.setLoading(false);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  iconSize: 20,
                  onPressed: () async {
                    if (await _controller.canGoForward()) {
                      _lk.currentState.setLoading(true);
                      await _controller.goForward();
                      await Future.delayed(Duration(seconds: 1));
                      _lk.currentState.setLoading(false);
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Medium Reader'),
                ),
              ],
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.content_copy),
                onPressed: () async {
                  ClipboardManager.copyToClipBoard(
                          await _controller.currentUrl())
                      .then((result) {
                    final snackBar = SnackBar(
                      content: Text('Copied to Clipboard'),
                    );
                    _sk.currentState.showSnackBar(snackBar);
                    print("Copy to Clipboard");
                  }).catchError((e) {
                    print(e);
                    final snackBar = SnackBar(
                      content: Text(
                        'Some Error Occured',
                        style: TextStyle(color: Colors.red[300]),
                      ),
                    );
                    _sk.currentState.showSnackBar(snackBar);
                    print("Copy to Clipboard Failed");
                  });
                },
              ),
            ],
            bottom: ProgressIndicatorCustom(
              key: _lk,
            )),
        body: WebView(
          initialUrl: widget.url,
          navigationDelegate: (nr) {
            // CookieManager().clearCookies();
            _lk.currentState.setLoading(true);
            return NavigationDecision.navigate;
          },
          onWebViewCreated: (controller) {
            _controller = controller;
          },
          onPageFinished: (s) {
            _lk.currentState.setLoading(false);
          },
        ),
      ),
    );
  }
}

class ProgressIndicatorCustom extends StatefulWidget
    implements PreferredSizeWidget {
  const ProgressIndicatorCustom({
    Key key,
  }) : super(key: key);

  @override
  Size get preferredSize => Size(double.infinity, 1);

  @override
  ProgressIndicatorCustomState createState() => ProgressIndicatorCustomState();
}

class ProgressIndicatorCustomState extends State<ProgressIndicatorCustom> {
  bool _visible = true;
  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      backgroundColor: _visible ? Colors.grey[200] : Colors.teal,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
    );
  }

  void setLoading(bool ns) {
    setState(() {
      _visible = ns;
    });
  }
}
