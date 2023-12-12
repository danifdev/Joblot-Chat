import 'package:meta/meta.dart';

/// Represents the size object.
@immutable
class SizeModel {
  /// Creates [Size] from width and height.
  const SizeModel({
    required this.height,
    required this.width,
  });

  /// Height.
  final double height;

  /// Width.
  final double width;
}
