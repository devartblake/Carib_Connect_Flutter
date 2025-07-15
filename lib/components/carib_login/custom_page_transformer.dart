import 'package:flutter/material.dart';
import '../../core/helpers/math_helper.dart';
import '../../core/utils/math/matrix.dart';
import 'package:another_transformer_page_view/another_transformer_page_view.dart';

class CustomPageTransformer extends PageTransformer {
  @override
  Widget transform(Widget child, TransformInfo info) {
    final transform = perspective();
    final position = info.position!;
    final pageDt = 1 - position.abs();

    if (position > 0) {
      transform
        ..scale(lerp(0.6, 1.0, pageDt))
        ..rotateY(position * -1.5);
    } else {
      transform
        ..scale(lerp(0.6, 1.0, pageDt))
        ..rotateY(position * 1.5);
    }

    return Transform(
      alignment: Alignment.center,
      transform: transform,
      child: child,
    );
  }
}