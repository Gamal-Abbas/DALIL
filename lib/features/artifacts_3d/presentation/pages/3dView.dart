import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Model3DScreen extends StatefulWidget {
  final String assetPath;
  final String title;

  const Model3DScreen({
    super.key,
    required this.assetPath,
    required this.title,
  });

  @override
  State<Model3DScreen> createState() => _Model3DScreenState();
}

class _Model3DScreenState extends State<Model3DScreen> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Stack(
        children: [
          ModelViewer(
            src: widget.assetPath,
            alt: widget.title,
            ar: true,
            autoRotate: true,
            cameraControls: true,
            backgroundColor: Colors.black,
            javascriptChannels: {
              JavascriptChannel(
               'ModelLoaded',
                onMessageReceived: (message) {
                  if (mounted) {
                    setState(() => _isLoading = false);
                  }
                },
              ),
            },
            relatedJs: '''
              const modelViewer = document.querySelector('model-viewer');
              modelViewer.addEventListener('load', () => {
                ModelLoaded.postMessage('loaded');
              });
            ''',
          ),
          if (_isLoading)
            Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}