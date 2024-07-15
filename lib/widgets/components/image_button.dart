import 'package:flutter/material.dart';

class ImageButton extends StatefulWidget {
  final String normalImagePath;
  final String pressedImagePath;
  final String? buttonText;
  final VoidCallback onTap;
  final bool isEnabled;
  final double imageSizeX;
  final double imageSizeY;
  final double? containerSizeX;
  final double? containerSizeY;

  const ImageButton({
    super.key,
    required this.normalImagePath,
    required this.pressedImagePath,
    required this.onTap,
    required this.imageSizeX,
    required this.imageSizeY,
    this.containerSizeX,
    this.containerSizeY,
    this.buttonText,
    this.isEnabled = true,
  });

  @override
  State<ImageButton> createState() => _ImageButtonState();
}

class _ImageButtonState extends State<ImageButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    if (widget.isEnabled) {
      setState(() {
        _isPressed = true;
      });
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.isEnabled) {
      setState(() {
        _isPressed = false;
        widget.onTap();
      });
    }
  }

  void _onTapCancel() {
    if (widget.isEnabled) {
      setState(() {
        _isPressed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Background Image
          Image.asset(
            _isPressed ? widget.pressedImagePath : widget.normalImagePath,
            width: widget.imageSizeX,
            height: widget.imageSizeY,
            fit: BoxFit.fill,
          ),
          // Button Text
          if (widget.buttonText != null)
            Container(
              width: widget.containerSizeX!,
              height: widget.containerSizeY!,
              alignment: Alignment.topCenter,
              child: Text(
                widget.buttonText!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
