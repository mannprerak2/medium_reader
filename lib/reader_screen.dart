import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReaderScreen extends StatefulWidget {
  final String url;

  const ReaderScreen({Key key, this.url}) : super(key: key);
  @override
  _ReaderScreenState createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  bool showLoader = true;
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_controller == null) {
          return true;
        } else if (await _controller.canGoBack()) {
          _controller.goBack();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Medium Reader'),
          centerTitle: true,
          bottom: showLoader
              ? MyLinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : null,
        ),
        body: WebView(
          initialUrl: widget.url,
          onWebViewCreated: (controller) {
            _controller = controller;
          },
          onPageFinished: (s) {
            print(s);
            setState(() {
              showLoader = false;
            });
          },
        ),
      ),
    );
  }
}

class MyLinearProgressIndicator extends LinearProgressIndicator
    implements PreferredSizeWidget {
  MyLinearProgressIndicator({
    Key key,
    double value,
    Color backgroundColor,
    Animation<Color> valueColor,
  })  : preferredSize = Size(double.infinity, 2),
        super(
          key: key,
          value: value,
          backgroundColor: backgroundColor,
          valueColor: valueColor,
        );

  @override
  final Size preferredSize;
}
