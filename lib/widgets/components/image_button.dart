import 'package:flutter/material.dart';

class ImageButton extends StatefulWidget {
  final String normalImagePath;
  final String pressedImagePath;
  final String? buttonText;
  final VoidCallback onTap;
  final bool isEnabled;

  const ImageButton({
    super.key,
    required this.normalImagePath,
    required this.pressedImagePath,
    required this.onTap,
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
            width: 60,
            height: 35,
            fit: BoxFit.cover,
          ),
          // Button Text
          Container(
            width: 75,
            height: 44,
            alignment: Alignment.topCenter,
            child: widget.buttonText != null
                ? Text(
                    widget.buttonText!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  final bool isSpinning;
  final VoidCallback startSpinning;

  const MyWidget({
    super.key,
    required this.isSpinning,
    required this.startSpinning,
  });

  @override
  Widget build(BuildContext context) {
    return ImageButton(
      buttonText: 'Go',
      onTap: () {
        if (!isSpinning) {
          startSpinning();
        } else {
          // Do nothing, button is disabled
        }
      },
      pressedImagePath: 'assets/images/fruit/fruit_btn_bet_100.png',
      normalImagePath: 'assets/images/fruit/fruit_btn_bet_10.png',
      isEnabled: !isSpinning,
    );
  }
}
