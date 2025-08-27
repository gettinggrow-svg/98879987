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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      home: const WebViewScreen(),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;

  final List<String> _instances = <String>[
    // Список зеркал (можно менять в коде)
    'https://piped.video',
    'https://piped.projectsegfau.lt',
    'https://yt.artemislena.eu',
    'https://invidious.snopyta.org',
    'https://invidious.io',
  ];

  int _current = 0;
  bool _showInsult = false; // переключатель фразы

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF000000))
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (request) {
          // Разрешаем все https ссылки
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse(_instances[_current]));
  }

  void _reload() {
    _controller.reload();
  }

  void _goBack() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
    }
  }

  void _goForward() async {
    if (await _controller.canGoForward()) {
      _controller.goForward();
    }
  }

  void _nextInstance() {
    setState(() {
      _current = (_current + 1) % _instances.length;
      _controller.loadRequest(Uri.parse(_instances[_current]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('YouTube Mirror Viewer'),
            if (_showInsult)
              const Text(
                'Лёшка G0vно3жка',
                style: TextStyle(fontSize: 12),
              ),
          ],
        ),
        actions: [
          IconButton(onPressed: _goBack, icon: const Icon(Icons.arrow_back)),
          IconButton(onPressed: _goForward, icon: const Icon(Icons.arrow_forward)),
          IconButton(onPressed: _reload, icon: const Icon(Icons.refresh)),
          IconButton(
            tooltip: 'Сменить зеркало',
            onPressed: _nextInstance,
            icon: const Icon(Icons.route),
          ),
          const SizedBox(width: 8),
          Switch(
            value: _showInsult,
            onChanged: (v) => setState(() => _showInsult = v),
          ),
        ],
      ),
      body: SafeArea(child: WebViewWidget(controller: _controller)),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          'Зеркало: ${_instances[_current]}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
