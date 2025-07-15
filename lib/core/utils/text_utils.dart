import 'package:flutter/material.dart';

class TextUtils extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;
  final bool? weight;

  const TextUtils({super.key, required this.text, this.size, this.color, this.weight});

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: TextStyle(color: color??Colors.black, fontSize:size?? 16,
          fontWeight: weight==null? FontWeight.w600: FontWeight.w700
      ),
    );
  }
}
