import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:moonpatrol/services/dot.env_service.dart';

class ZoomableCameraPreview extends StatefulWidget {
  final CameraController controller;
  final Widget? child;
  final ValueChanged<double>? onZoomChanged;

  const ZoomableCameraPreview({
    super.key,
    required this.controller,
    this.child,
    this.onZoomChanged,
  });

  @override
  State<ZoomableCameraPreview> createState() => _ZoomableCameraPreviewState();
}

class _ZoomableCameraPreviewState extends State<ZoomableCameraPreview> {
  double _currentZoom = EnvConfig.zoomLevel;
  double _baseZoom = EnvConfig.zoomLevel;
  double _minZoom = 0;
  double _maxZoom = 10.0;

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

      widget.onZoomChanged?.call(_currentZoom);
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
