import 'package:flutter/rendering.dart';

/// Perspective makes objects that are farther away appear smaller.
///
/// The [weight] parameter increases and decreases the amount of perspective,
/// similar to zooming in and out with a zoom lens on a camera. The bigger
/// this number, the more pronounced the perspective, which makes it look
/// like you are closer to the viewed object.
///
/// Example Usage:
/// ```dart
/// Container(
///   transform: perspective(0.002),
///   child: Text("Perspective Example"),
/// )
/// ```
///
/// [weight] defaults to 0.001 for a subtle perspective effect.
Matrix4 perspective([double weight = .001]) =>
    Matrix4.identity()..setEntry(3, 2, weight);

/// Applies a rotation effect on the X-axis.
///
/// The [angle] is in radians. Use [math.pi] for rotations (e.g., math.pi / 4 for 45 degrees).
Matrix4 rotateX(double angle) => Matrix4.identity()..rotateX(angle);

/// Applies a rotation effect on the Y-axis.
///
/// The [angle] is in radians. Use [math.pi] for rotations (e.g., math.pi / 4 for 45 degrees).
Matrix4 rotateY(double angle) => Matrix4.identity()..rotateY(angle);

/// Applies a rotation effect on the Z-axis.
///
/// The [angle] is in radians. Use [math.pi] for rotations (e.g., math.pi / 4 for 45 degrees).
Matrix4 rotateZ(double angle) => Matrix4.identity()..rotateZ(angle);

/// Combines perspective with rotation around the X-axis.
///
/// The [weight] parameter controls the perspective, and [angleX] controls the rotation in radians.
Matrix4 perspectiveWithRotateX(double weight, double angleX) =>
    perspective(weight)..rotateX(angleX);

/// Combines perspective with rotation around the Y-axis.
///
/// The [weight] parameter controls the perspective, and [angleY] controls the rotation in radians.
Matrix4 perspectiveWithRotateY(double weight, double angleY) =>
    perspective(weight)..rotateY(angleY);

/// Combines perspective with rotation around the Z-axis.
///
/// The [weight] parameter controls the perspective, and [angleZ] controls the rotation in radians.
Matrix4 perspectiveWithRotateZ(double weight, double angleZ) =>
    perspective(weight)..rotateZ(angleZ);

/// Creates a translation matrix that moves an object in 3D space.
///
/// - [dx]: Horizontal movement (X-axis).
/// - [dy]: Vertical movement (Y-axis).
/// - [dz]: Depth movement (Z-axis, positive values move the object further away).
Matrix4 translate(double dx, double dy, double dz) =>
    Matrix4.identity()..translate(dx, dy, dz);

/// Combines perspective, rotation, and translation for advanced 3D transformations.
///
/// - [weight]: Controls the perspective.
/// - [angleX], [angleY], [angleZ]: Rotations around the X, Y, and Z axes respectively (in radians).
/// - [dx], [dy], [dz]: Translation along the X, Y, and Z axes respectively.
Matrix4 combinedTransform({
  double weight = .001,
  double angleX = 0,
  double angleY = 0,
  double angleZ = 0,
  double dx = 0,
  double dy = 0,
  double dz = 0,
}) =>
    perspective(weight)
      ..rotateX(angleX)
      ..rotateY(angleY)
      ..rotateZ(angleZ)
      ..translate(dx, dy, dz);