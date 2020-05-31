import 'package:flutter/material.dart';

class WideButton extends StatelessWidget {
  final Color background;
  final VoidCallback onPressed;
  final String title;
  final Color color;

  WideButton({
    @required this.background,
    @required this.onPressed,
    @required this.title,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 55,
      child: FlatButton(
        onPressed: () {
          onPressed();
        },
        color: background,
        highlightColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(color: Colors.white),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: color ?? Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
