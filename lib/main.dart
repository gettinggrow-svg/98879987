import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Mirror',
      theme: ThemeData.dark(),
      home: const YoutubeMirror(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class YoutubeMirror extends StatefulWidget {
  const YoutubeMirror({super.key});

  @override
  State<YoutubeMirror> createState() => _YoutubeMirrorState();
}

class _YoutubeMirrorState extends State<YoutubeMirror> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse("https://piped.video"), // <- зеркало YouTube
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("YouTube Mirror")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
