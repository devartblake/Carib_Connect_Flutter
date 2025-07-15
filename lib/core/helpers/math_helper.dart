import 'dart:math';

// Radian math function
double toRadian(double degree) => degree * pi / 180;

// Lerp math function
double lerp(double start, double end, double percent) {
  return start + percent * (end - start);
}
