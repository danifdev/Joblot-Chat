import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A class that represents a loading indicator while paginating more messages.
@immutable
class LoadMoreIndicator extends Equatable {
  const LoadMoreIndicator({
    required this.text,
  });

  /// Text to show in a loading.
  final String text;

  /// Equatable props.
  @override
  List<Object> get props => [text];
}
