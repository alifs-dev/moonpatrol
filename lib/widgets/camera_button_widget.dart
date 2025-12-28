import 'package:flutter/material.dart';

/// Widget bouton de capture photo
class CameraButtonWidget extends StatelessWidget {
  final bool isCapturing;
  final VoidCallback onPressed;

  const CameraButtonWidget({
    super.key,
    required this.isCapturing,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: isCapturing ? null : onPressed,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.9),
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child:
                isCapturing
                    ? const Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.blue,
                      ),
                    )
                    : const Icon(Icons.camera_alt, size: 35, color: Colors.blue),
          ),
        ),
      ),
    );
  }
}
