import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

const String contents = '''
<!DOCTYPE html><html>
<head><title>Example</title></head>
<body>
<p>
This is a WebView
</p>
<p>
Tap the Google link to push a new Flutter page
</p>
<ul>
<ul><a href="https://www.google.com/">https://www.google.com/</a></ul>
</ul>
</body>
</html>
''';

final String contentBase64 = base64Encode(const Utf8Encoder().convert(contents));
final String dataUrl = 'data:text/html;base64,$contentBase64';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebView Demo',
      home: WebViewPage(),
    );
  }
}

class WebViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new WebView(
        initialUrl: dataUrl,
        navigationDelegate: (NavigationRequest r) => _interceptNavigation(context, r),
      ),
    );
  }

  static NavigationDecision _interceptNavigation(BuildContext context, NavigationRequest navigationRequest) {
    if (navigationRequest.url == 'https://www.google.com/') {
      print('Preventing ${navigationRequest.url}');
      Navigator.of(context).push(_createRoute());
      return NavigationDecision.prevent;
    }
    print('Navigating to ${navigationRequest.url}');
    return NavigationDecision.navigate;
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => AnotherPage(),
  );
}

class AnotherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('This is a Flutter page'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, semanticLabel: 'add',),
        onPressed: () { print('add pressed'); },
      ),
    );
  }
}

