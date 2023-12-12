import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message_received_time.g.dart';

@immutable
@JsonSerializable()
class MessageReceivedTime {
  final String? timeText;
  final DateTime? timeDate;
  const MessageReceivedTime({this.timeText, this.timeDate});

  factory MessageReceivedTime.fromJson(Map<String, dynamic> json) =>
      _$MessageReceivedTimeFromJson(json);
}
