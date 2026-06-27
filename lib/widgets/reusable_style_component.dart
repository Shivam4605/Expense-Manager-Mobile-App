import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ReusableStyleComponent extends StatefulWidget {
  String message;
  double fontsize;
  FontWeight fontWeight;
  Color color;
  BuildContext context;

  ReusableStyleComponent({
    super.key,
    required this.color,
    required this.fontWeight,
    required this.fontsize,
    required this.message,
    required this.context,
  });

  @override
  State<ReusableStyleComponent> createState() => _ReusableStyleComponentState();
}

class _ReusableStyleComponentState extends State<ReusableStyleComponent> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.message,
      style: TextStyle(
        color: widget.color,
        fontWeight: widget.fontWeight,
        fontSize: widget.fontsize,
      ),
    );
  }
}
