import 'package:flutter/material.dart';

class ImageLable extends StatefulWidget {
  final String imagePath;
  final String text;
  final double sizeX;
  final double sizeY;

  const ImageLable({
    super.key,
    required this.imagePath,
    required this.sizeX,
    required this.sizeY,
    required this.text,
  });

  @override
  State<ImageLable> createState() => _ImageButtonState();
}

class _ImageButtonState extends State<ImageLable> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Background Image
          Image.asset(
            widget.imagePath,
            width: widget.sizeX,
            height: widget.sizeY,
            fit: BoxFit.fill,
          ),

          // Text
          Container(
            width: widget.sizeX,
            height: widget.sizeY,
            alignment: Alignment.topCenter,
            child: Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
