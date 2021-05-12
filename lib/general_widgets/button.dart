import 'package:flutter/material.dart';
import 'package:image_cloud_server/utils/design.dart';
import 'package:image_cloud_server/utils/text.dart';
import 'min_container.dart';

class LButton extends StatefulWidget {
  final String text;
  final Color color;
  final Function() onPressed;

  const LButton({
    Key? key,
    required this.text,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  _LButtonState createState() => _LButtonState();
}

class _LButtonState extends State<LButton> {
  bool overlay = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        overlay = true;
        setState(() {});

        await Future.delayed(Duration(milliseconds: 700));

        overlay = false;
        setState(() {});

        widget.onPressed();
      },
      child: MinContainer(
        alignment: Alignment.center,
        height: 61,
        radius: 11,
        color: widget.color,
        child: MinContainer(
          radius: 11,
          alignment: Alignment.center,
          color: overlay ? Colors.white10 : null,
          child: Text(
            widget.text,
            style: TextDesign.normal(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class FloatButton extends StatelessWidget {
  final Color? color;
  final Function() onPressed;
  final Color? iconColor;
  final IconData iconData;

  const FloatButton({
    Key? key,
    this.color,
    this.iconColor,
    required this.iconData,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: color ?? Design.kRed,
      onPressed: onPressed,
      child: Center(
        child: Icon(
          iconData,
          color: iconColor ?? Colors.grey[300],
        ),
      ),
    );
  }
}
