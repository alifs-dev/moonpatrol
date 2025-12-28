import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ZoomableCameraPreview extends StatefulWidget {
  final CameraController controller;
  final Widget? child;

  const ZoomableCameraPreview({super.key, required this.controller, this.child});

  @override
  State<ZoomableCameraPreview> createState() => _ZoomableCameraPreviewState();
}

class _ZoomableCameraPreviewState extends State<ZoomableCameraPreview> {
  double _currentZoom = 1.0;
  double _baseZoom = 1.0;
  double _minZoom = 1.0;
  double _maxZoom = 1.0;

  @override
  void initState() {
    super.initState();
    _initZoom();
  }

  Future<void> _initZoom() async {
    _minZoom = await widget.controller.getMinZoomLevel();
    _maxZoom = await widget.controller.getMaxZoomLevel();
    _currentZoom = _minZoom;
  }

  void _onScaleStart(ScaleStartDetails details) {
    _baseZoom = _currentZoom;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) async {
    double newZoom = (_baseZoom * details.scale).clamp(_minZoom, _maxZoom);

    if (newZoom != _currentZoom) {
      _currentZoom = newZoom;
      await widget.controller.setZoomLevel(_currentZoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      child: CameraPreview(widget.controller, child: widget.child),
    );
  }
}
